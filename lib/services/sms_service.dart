import '../models/sms_raw_log.dart';

class SmsService {
  Future<bool> requestPermission() async {
    return false;
  }

  Future<List<SmsRawLog>> fetchInboxHistory() async {
    return [];
  }

  Stream<SmsRawLog> watchIncomingSms() async* {
    // PHASE 3: implement full SMS parsing here
    yield* const Stream.empty();
  }
}