import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sms_raw_log.dart';
import 'sms/sms_parser.dart';
import 'ai/llm_parser_service.dart';

class InboxSyncResult {
  final SmsRawLog log;
  final ParsedSms parsed;
  InboxSyncResult(this.log, this.parsed);
}

class SmsService {
  final Telephony telephony = Telephony.instance;
  final StreamController<SmsRawLog> _incomingController = StreamController<SmsRawLog>.broadcast();

  static String lastDiagnostic = "No scans yet.";

  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<List<InboxSyncResult>> fetchInboxHistory({String? geminiApiKey}) async {
    List<InboxSyncResult> results = [];
    int totalScanned = 0;
    int totalInDateRange = 0;
    int totalParsed = 0;
    List<String> failedSamples = [];

    try {
      final status = await Permission.sms.request();
      if (!status.isGranted) {
        lastDiagnostic = "SMS Permission Denied.";
        return results;
      }

      // Get SMS messages
      List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      totalScanned = messages.length;

      // We only care about bank messages, usually from alphanumeric senders
      final now = DateTime.now();
      // Look back only to the start of the current month
      final cutoffDate = DateTime(now.year, now.month, 1); 

      for (var msg in messages) {
        if (msg.date == null || msg.address == null || msg.body == null) continue;
        
        final date = DateTime.fromMillisecondsSinceEpoch(msg.date!);
        if (date.isBefore(cutoffDate)) continue; // Keep searching in case of sorting anomalies
        
        totalInDateRange++;

        // We no longer strictly filter by sender address length or digits here
        // because the sms_parser is robust enough to reject non-financial SMS,
        // and some banks resolve to full names like 'Punjab national bank'.

        // Try regex first for speed
        final parsed = SmsParser.parseMessage(msg.address!, msg.body!);
        if (parsed != null) {
          totalParsed++;
          results.add(InboxSyncResult(
            SmsRawLog(
              id: const Uuid().v4(),
              rawBody: msg.body!,
              sender: msg.address!,
              receivedAt: date,
              isParsed: true,
            ),
            parsed,
          ));
        } else {
          // If regex failed, check if we should batch it for LLM
          if (geminiApiKey != null && geminiApiKey.isNotEmpty && SmsParser.mightBeTransaction(msg.body!)) {
             failedSamples.add("LLM_BATCHED|${msg.address}|${msg.body}|${msg.date}");
          } else {
             final lBody = msg.body!.toLowerCase();
             if (failedSamples.length < 5 && (lBody.contains('inr') || lBody.contains('rs') || lBody.contains('debited') || lBody.contains('credited'))) {
               failedSamples.add("Sender: ${msg.address}\nBody: ${msg.body}");
             }
          }
        }
      }
      // Process LLM batches
      final llmBatches = failedSamples.where((s) => s.startsWith("LLM_BATCHED|")).toList();
      failedSamples.removeWhere((s) => s.startsWith("LLM_BATCHED|")); // keep true failures
      
      if (geminiApiKey != null && llmBatches.isNotEmpty) {

          int batchSize = 15;
          for (int i = 0; i < llmBatches.length; i += batchSize) {
              final batch = llmBatches.skip(i).take(batchSize).toList();
              final inputList = batch.map((s) {
                  final parts = s.split('|'); // LLM_BATCHED|sender|body|date
                  return {
                      "id": parts[1] + parts[3],
                      "sender": parts[1],
                      "body": parts[2],
                      "dateStr": parts[3]
                  };
              }).toList();
              
              final llmResults = await LlmParserService.parseBatch(inputList, geminiApiKey);
              
              for (int j = 0; j < llmResults.length; j++) {
                  if (llmResults[j] != null) {
                      totalParsed++;
                      results.add(InboxSyncResult(
                          SmsRawLog(
                              id: const Uuid().v4(),
                              rawBody: inputList[j]['body']!,
                              sender: inputList[j]['sender']!,
                              receivedAt: DateTime.fromMillisecondsSinceEpoch(int.parse(inputList[j]['dateStr']!)),
                              isParsed: true,
                          ),
                          llmResults[j]!
                      ));
                  }
              }
          }
      }

      lastDiagnostic = "Total SMS seen: $totalScanned\nTotal in Range: $totalInDateRange\nTotal successfully parsed: $totalParsed\n\nFailed Samples:\n${failedSamples.join('\n\n')}";
    } catch (e) {
      lastDiagnostic = "Crash: $e";
      print("Error fetching inbox: $e");
    }
    return results;
  }


  bool _isListening = false;

  Stream<SmsRawLog> watchIncomingSms({String? geminiApiKey}) {
    if (_isListening) return _incomingController.stream;
    
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage msg) async {
        print('=== SMS RECEIVED EVENT: ${msg.address} ===');
        print('Body: ${msg.body}');
        if (msg.address == null || msg.body == null || msg.date == null) return;
        
        final parsed = await SmsParser.parseMessageAsync(msg.address!, msg.body!, geminiApiKey: geminiApiKey);
        if (parsed != null) {
          final log = SmsRawLog(
            id: const Uuid().v4(),
            rawBody: msg.body!,
            sender: msg.address!,
            receivedAt: DateTime.fromMillisecondsSinceEpoch(msg.date!),
            isParsed: true,
          );
          _incomingController.add(log);
        }
      },
      listenInBackground: false,
    );
    _isListening = true;
    return _incomingController.stream;
  }
}