import 'package:uuid/uuid.dart';
import '../../models/transaction.dart';
import '../../models/sms_raw_log.dart';
import '../../core/constants/app_constants.dart';
import 'sms_parser.dart';
// Single source of truth — replaces the old AutoCategorizer
import '../ai/category_classifier.dart';

/// Converts a [ParsedSms] + [SmsRawLog] into a [Transaction] ready to be
/// persisted. Uses [CategoryClassifier] for consistent categorization across
/// both the SMS pipeline and the AI engine.
class SmsToTransaction {
  /// Convert a parsed SMS into a [Transaction].
  ///
  /// - Category is derived using [CategoryClassifier.classifyWithDirection] so
  ///   that uncategorized credit transactions default to [Category.income].
  /// - [PaymentMethod] is inferred from UPI ref ID presence.
  /// - [Confidence] is taken directly from the parser.
  static Transaction convert(ParsedSms parsed, SmsRawLog rawLog) {
    final category = CategoryClassifier.classifyWithDirection(
      parsed.merchantName ?? '',
      parsed.direction,
    );

    PaymentMethod paymentMethod = PaymentMethod.unknown;
    if (parsed.upiRefId != null) {
      paymentMethod = PaymentMethod.upi;
    } else if (parsed.isCardTransaction) {
      paymentMethod = PaymentMethod.card;
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

  /// Returns true if [newTxn] is likely a duplicate of an existing transaction.
  ///
  /// Checks: same amount + same direction + date within 2 minutes.
  static bool isDuplicate(Transaction newTxn, List<Transaction> existingTxns) {
    for (final existing in existingTxns) {
      if (existing.amount == newTxn.amount &&
          existing.direction == newTxn.direction) {
        final diff = existing.date.difference(newTxn.date).inMinutes.abs();
        if (diff <= 2) return true;
      }
    }
    return false;
  }
}
