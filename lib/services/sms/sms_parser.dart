import '../../core/constants/app_constants.dart';

class ParsedSms {
  final double amount;
  final TransactionDirection direction;
  final String? merchantName;
  final String? upiRefId;
  final String bankSource;
  final Confidence confidence;

  ParsedSms({
    required this.amount,
    required this.direction,
    this.merchantName,
    this.upiRefId,
    required this.bankSource,
    required this.confidence,
  });
}

class SmsParser {
  static ParsedSms? parseMessage(String sender, String body) {
    body = body.toLowerCase();
    
    // Quick filter: Must look like a financial SMS
    if (!body.contains('rs.') && !body.contains('inr') && !body.contains('rs ')) {
      return null;
    }
    
    // Extract Bank Name from sender
    String bankSource = _extractBankName(sender);

    // Extract Direction
    TransactionDirection? direction;
    if (body.contains('debited') || body.contains('paid') || body.contains('sent')) {
      direction = TransactionDirection.debit;
    } else if (body.contains('credited') || body.contains('received')) {
      direction = TransactionDirection.credit;
    }
    
    if (direction == null) return null;

    // Extract Amount
    double? amount = _extractAmount(body);
    if (amount == null) return null;

    // Extract Merchant
    String? merchant = _extractMerchant(body, direction);

    // Extract UPI Ref
    String? upiRef = _extractUpiRef(body);

    // Calculate Confidence
    Confidence confidence = Confidence.low;
    if (merchant != null && merchant.isNotEmpty && direction != null && amount > 0) {
      confidence = Confidence.high;
    } else if (direction != null && amount > 0) {
      confidence = Confidence.medium;
    }

    return ParsedSms(
      amount: amount,
      direction: direction,
      merchantName: merchant,
      upiRefId: upiRef,
      bankSource: bankSource,
      confidence: confidence,
    );
  }

  static String _extractBankName(String sender) {
    sender = sender.toUpperCase();
    if (sender.contains('SBI')) return 'SBI';
    if (sender.contains('HDFC')) return 'HDFC Bank';
    if (sender.contains('ICICI')) return 'ICICI Bank';
    if (sender.contains('AXIS')) return 'Axis Bank';
    if (sender.contains('KOTAK')) return 'Kotak Bank';
    if (sender.contains('PAYTM')) return 'Paytm';
    return 'Unknown Bank';
  }

  static double? _extractAmount(String body) {
    // Matches Rs. 100, Rs 100, INR 100, Rs.100.50
    final RegExp amountRegExp = RegExp(r'(?:rs\.?|inr)\s*([\d,]+\.?\d*)');
    final match = amountRegExp.firstMatch(body);
    if (match != null && match.group(1) != null) {
      String amountStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(amountStr);
    }
    return null;
  }

  static String? _extractMerchant(String body, TransactionDirection direction) {
    String? merchant;
    if (direction == TransactionDirection.debit) {
      // Look for "to " or "at " or "for "
      final toMatch = RegExp(r'to\s+([a-zA-Z0-9\s]+?)(?:\s+on|\.|\s+ref|\s+upi|$)').firstMatch(body);
      if (toMatch != null) merchant = toMatch.group(1)?.trim();
      
      if (merchant == null) {
        final atMatch = RegExp(r'at\s+([a-zA-Z0-9\s]+?)(?:\s+on|\.|\s+ref|\s+upi|$)').firstMatch(body);
        if (atMatch != null) merchant = atMatch.group(1)?.trim();
      }
    } else {
      // Look for "from " or "by "
      final fromMatch = RegExp(r'from\s+([a-zA-Z0-9\s]+?)(?:\s+on|\.|\s+ref|\s+upi|$)').firstMatch(body);
      if (fromMatch != null) merchant = fromMatch.group(1)?.trim();
    }
    
    // Clean up
    if (merchant != null) {
      if (merchant.length < 3) return null;
      // uppercase first letters
      return merchant.split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
    }
    return null;
  }

  static String? _extractUpiRef(String body) {
    final refMatch = RegExp(r'(?:ref no|upi ref|txn id)[:\-\s]*(\d{12}|\d{10})').firstMatch(body);
    if (refMatch != null) return refMatch.group(1);
    return null;
  }
}
