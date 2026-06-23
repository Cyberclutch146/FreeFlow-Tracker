import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sms_raw_log.dart';
import '../database/database_service.dart';
import 'sms/sms_parser.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;
  final StreamController<SmsRawLog> _incomingController = StreamController<SmsRawLog>.broadcast();

  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<List<SmsRawLog>> fetchInboxHistory() async {
    List<SmsRawLog> rawLogs = [];
    try {
      final status = await Permission.sms.request();
      if (!status.isGranted) return rawLogs;

      // Get SMS messages
      List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      // We only care about bank messages, usually from alphanumeric senders
      final cutoffDate = DateTime.now().subtract(const Duration(days: 180)); // 6 months

      for (var msg in messages) {
        if (msg.date == null || msg.address == null || msg.body == null) continue;
        
        final date = DateTime.fromMillisecondsSinceEpoch(msg.date!);
        if (date.isBefore(cutoffDate)) break; // Since it's sorted DESC, we can stop

        // Simple filter to skip obvious non-bank messages
        if (msg.address!.length > 10 || RegExp(r'^\+?\d+$').hasMatch(msg.address!)) {
          // It's likely a phone number, not an institutional sender like "XX-HDFCBK"
          continue;
        }

        final parsed = SmsParser.parseMessage(msg.address!, msg.body!);
        if (parsed != null) {
          rawLogs.add(SmsRawLog(
            id: const Uuid().v4(),
            rawBody: msg.body!,
            sender: msg.address!,
            receivedAt: date,
            isParsed: true,
          ));
        }
      }
    } catch (e) {
      print("Error fetching inbox: $e");
    }
    return rawLogs;
  }

  bool _isListening = false;

  Stream<SmsRawLog> watchIncomingSms() {
    if (_isListening) return _incomingController.stream;
    
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage msg) {
        print('=== SMS RECEIVED EVENT: ${msg.address} ===');
        print('Body: ${msg.body}');
        if (msg.address == null || msg.body == null || msg.date == null) return;
        
        final parsed = SmsParser.parseMessage(msg.address!, msg.body!);
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