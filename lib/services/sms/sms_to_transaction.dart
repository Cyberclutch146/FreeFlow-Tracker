import 'package:uuid/uuid.dart';
import '../../models/transaction.dart';
import '../../models/sms_raw_log.dart';
import '../../core/constants/app_constants.dart';
import 'sms_parser.dart';
import '../categorization/auto_categorizer.dart';

class SmsToTransaction {
  static Transaction convert(ParsedSms parsed, SmsRawLog rawLog) {
    final category = AutoCategorizer.categorize(parsed.merchantName);
    
    PaymentMethod paymentMethod = PaymentMethod.unknown;
    if (parsed.upiRefId != null) {
      paymentMethod = PaymentMethod.upi;
    }

    return Transaction(
      id: const Uuid().v4(),
      amount: parsed.amount,
      direction: parsed.direction,
      category: category,
      date: rawLog.receivedAt,
      paymentMethod: paymentMethod,
      isRecurring: false,
      smsRawLogId: rawLog.id,
      confidence: parsed.confidence,
      isConfirmed: false,
      merchantName: parsed.merchantName,
      upiRefId: parsed.upiRefId,
      bankSource: parsed.bankSource,
    );
  }

  static bool isDuplicate(Transaction newTxn, List<Transaction> existingTxns) {
    for (final existing in existingTxns) {
      if (existing.amount == newTxn.amount && 
          existing.direction == newTxn.direction) {
        
        // Check if dates are within 2 minutes of each other
        final diff = existing.date.difference(newTxn.date).inMinutes.abs();
        if (diff <= 2) {
          return true; // Likely a duplicate
        }
      }
    }
    return false;
  }
}
