import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:uuid/uuid.dart';
import '../models/sms_raw_log.dart';
import '../database/database_service.dart';
import 'sms/sms_parser.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;
  final StreamController<SmsRawLog> _incomingController = StreamController<SmsRawLog>.broadcast();

  Future<bool> requestPermission() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    return permissionsGranted ?? false;
  }

  Future<List<SmsRawLog>> fetchInboxHistory() async {
    List<SmsRawLog> rawLogs = [];
    try {
      bool? hasPermission = await telephony.requestPhoneAndSmsPermissions;
      if (hasPermission != true) return rawLogs;

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

  Stream<SmsRawLog> watchIncomingSms() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage msg) {
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
    return _incomingController.stream;
  }
}