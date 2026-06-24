import '../../core/constants/app_constants.dart';

/// Result of parsing a single bank SMS message.
class ParsedSms {
  final double amount;
  final TransactionDirection direction;
  final String? merchantName;
  final String? upiRefId;
  final String bankSource;
  final Confidence confidence;
  /// True when the SMS indicates this was a card (credit/debit card) payment.
  final bool isCardTransaction;

  ParsedSms({
    required this.amount,
    required this.direction,
    this.merchantName,
    this.upiRefId,
    required this.bankSource,
    required this.confidence,
    this.isCardTransaction = false,
  });
}

/// Parses Indian bank SMS messages into structured [ParsedSms] objects.
///
/// Supports UPI, card, NEFT, and general debit/credit SMS formats.
/// Tuned for Indian banking vocabulary including Hindi/regional mixed patterns.
class SmsParser {
  /// Attempt to parse [body] from [sender] into a [ParsedSms].
  /// Returns null if the message doesn't look like a financial transaction.
  static ParsedSms? parseMessage(String sender, String body) {
    final lowerBody = body.toLowerCase();

    // Quick filter: must contain a currency marker or common financial terms
    if (!lowerBody.contains('rs.') &&
        !lowerBody.contains('inr') &&
        !lowerBody.contains('rs ') &&
        !lowerBody.contains('₹') &&
        !lowerBody.contains('\$') &&
        !lowerBody.contains('usd') &&
        !lowerBody.contains('€') &&
        !lowerBody.contains('£')) {
      return null;
    }

    final bankSource = _extractBankName(sender);
    final direction = _extractDirection(lowerBody);
    if (direction == null) return null;

    final amount = _extractAmount(lowerBody);
    if (amount == null || amount <= 0) return null;

    final isCard = _isCardTransaction(lowerBody);
    final merchant = _extractMerchant(lowerBody, direction);
    final upiRef = _extractUpiRef(lowerBody);

    // Confidence: high if we have both merchant and amount, medium if only amount
    final confidence = (merchant != null && merchant.isNotEmpty)
        ? Confidence.high
        : Confidence.medium;

    return ParsedSms(
      amount: amount,
      direction: direction,
      merchantName: merchant,
      upiRefId: upiRef,
      bankSource: bankSource,
      confidence: confidence,
      isCardTransaction: isCard,
    );
  }

  // ── Direction detection ───────────────────────────────────────────────────

  static TransactionDirection? _extractDirection(String body) {
    // Debit signals
    const debitSignals = [
      'debited', 'deducted', 'paid', 'sent', 'withdrawn', 'withdrawal',
      'purchase', 'used at', 'charged', 'spent', 'payment of', 'transferred to',
      'trf to', 'transfer to', 'debit', 'payment done', 'imps/neft sent',
    ];
    // Credit signals
    const creditSignals = [
      'credited', 'received', 'deposited', 'added', 'refund', 'cashback',
      'transfer in', 'trf from', 'transfer from', 'imps received',
      'neft received', 'credit', 'money received',
    ];

    for (final s in debitSignals) {
      if (body.contains(s)) return TransactionDirection.debit;
    }
    for (final s in creditSignals) {
      if (body.contains(s)) return TransactionDirection.credit;
    }
    return null;
  }

  // ── Amount extraction ────────────────────────────────────────────────────

  static double? _extractAmount(String body) {
    // Matches: Rs. 1,000.50 | Rs 1000 | INR 50,000 | ₹500 | $50 | USD 50.00 | € 50 | £ 50
    final amountRegExp = RegExp(
      r'(?:rs\.?\s*|inr\s*|₹\s*|\$\s*|usd\s*|€\s*|£\s*)([\d,]+\.?\d*)',
      caseSensitive: false,
    );
    final match = amountRegExp.firstMatch(body);
    if (match != null && match.group(1) != null) {
      final amountStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(amountStr);
    }
    return null;
  }

  // ── Merchant extraction ──────────────────────────────────────────────────

  static String? _extractMerchant(String body, TransactionDirection direction) {
    String? merchant;

    if (direction == TransactionDirection.debit) {
      // Try UPI VPA first (most specific)
      final vpaMatch = RegExp(
        r'(?:to\s+vpa\s+|vpa\s+|to\s+)([a-zA-Z0-9.\-@]+@[a-zA-Z0-9.\-]+)',
      ).firstMatch(body);
      if (vpaMatch != null) return vpaMatch.group(1)?.toLowerCase().trim();

      // "to <merchant>" pattern — allow hyphens, ampersands, slashes, dots
      final toMatch = RegExp(
        r'\bto\b\s+([a-zA-Z0-9\s\-&/\.]+?)(?:\s+on\b|\s+ref\b|\s+upi\b|\s+a/c|\.|$)',
      ).firstMatch(body);
      if (toMatch != null) merchant = toMatch.group(1)?.trim();

      // "at <merchant>" pattern
      if (merchant == null) {
        final atMatch = RegExp(
          r'\bat\b\s+([a-zA-Z0-9\s\-&/\.]+?)(?:\s+on\b|\s+ref\b|\s+upi\b|\.|$)',
        ).firstMatch(body);
        if (atMatch != null) merchant = atMatch.group(1)?.trim();
      }

      // "for <merchant>" pattern
      if (merchant == null) {
        final forMatch = RegExp(
          r'\bfor\b\s+([a-zA-Z0-9\s\-&/\.]+?)(?:\s+on\b|\s+ref\b|\.|$)',
        ).firstMatch(body);
        if (forMatch != null) merchant = forMatch.group(1)?.trim();
      }
    } else {
      // Credit: try UPI VPA
      final vpaMatch = RegExp(
        r'(?:from\s+vpa\s+|vpa\s+|from\s+)([a-zA-Z0-9.\-@]+@[a-zA-Z0-9.\-]+)',
      ).firstMatch(body);
      if (vpaMatch != null) return vpaMatch.group(1)?.toLowerCase().trim();

      // "from <sender>" pattern
      final fromMatch = RegExp(
        r'\bfrom\b\s+([a-zA-Z0-9\s\-&/\.]+?)(?:\s+on\b|\s+ref\b|\s+upi\b|\.|$)',
      ).firstMatch(body);
      if (fromMatch != null) merchant = fromMatch.group(1)?.trim();
    }

    return _cleanMerchant(merchant);
  }

  static String? _cleanMerchant(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    // Remove trailing noise words
    raw = raw.replaceAll(
      RegExp(r'\b(your|the|a|an|account|ac|bank|upi|ref|no|on)\b', caseSensitive: false),
      '',
    ).trim();
    if (raw.length < 3) return null;
    // If VPA, keep as-is lowercase
    if (raw.contains('@')) return raw.toLowerCase();
    // Title-case for display
    return raw
        .split(RegExp(r'[\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  // ── Card transaction detection ───────────────────────────────────────────

  static bool _isCardTransaction(String body) {
    return body.contains('card') ||
        body.contains('credit card') ||
        body.contains('debit card') ||
        RegExp(r'card\s*(?:no|xx|ending|xxxx)').hasMatch(body);
  }

  // ── UPI ref extraction ───────────────────────────────────────────────────

  static String? _extractUpiRef(String body) {
    final refMatch = RegExp(
      r'(?:ref\s*no\.?|upi\s*ref\.?|txn\s*id\.?|transaction\s*id\.?)[\s:\-]*(\d{9,15})',
      caseSensitive: false,
    ).firstMatch(body);
    return refMatch?.group(1);
  }

  // ── Bank name extraction ─────────────────────────────────────────────────

  /// Extracts a human-readable bank name from the SMS sender ID.
  static String _extractBankName(String sender) {
    final s = sender.toUpperCase();

    // Major private banks
    if (s.contains('HDFC')) return 'HDFC Bank';
    if (s.contains('ICICI')) return 'ICICI Bank';
    if (s.contains('AXIS')) return 'Axis Bank';
    if (s.contains('KOTAK')) return 'Kotak Bank';
    if (s.contains('YES')) return 'Yes Bank';
    if (s.contains('IDFC')) return 'IDFC FIRST Bank';
    if (s.contains('INDUSIND') || s.contains('INDUS')) return 'IndusInd Bank';
    if (s.contains('FEDERAL') || s.contains('FEDBANK')) return 'Federal Bank';
    if (s.contains('RBL')) return 'RBL Bank';
    if (s.contains('BANDHAN')) return 'Bandhan Bank';
    if (s.contains('KARNATAKA') || s.contains('KBL')) return 'Karnataka Bank';
    if (s.contains('KARUR') || s.contains('KVB')) return 'Karur Vysya Bank';

    // Public sector banks
    if (s.contains('SBI') || s.contains('SBIINB')) return 'SBI';
    if (s.contains('PNB') || s.contains('PUNJAB')) return 'PNB';
    if (s.contains('BOB') || s.contains('BARODA')) return 'Bank of Baroda';
    if (s.contains('CANARA') || s.contains('CANBK')) return 'Canara Bank';
    if (s.contains('UNION')) return 'Union Bank';
    if (s.contains('INDIAN')) return 'Indian Bank';
    if (s.contains('CENTRAL')) return 'Central Bank';
    if (s.contains('UCO')) return 'UCO Bank';
    if (s.contains('DENA')) return 'Dena Bank';

    // Payments / wallets
    if (s.contains('PAYTM')) return 'Paytm';
    if (s.contains('PHONEPE') || s.contains('PHONEPE')) return 'PhonePe';
    if (s.contains('GPAY') || s.contains('GOOGLEPAY')) return 'Google Pay';
    if (s.contains('AMAZON')) return 'Amazon Pay';
    if (s.contains('BAJAJ')) return 'Bajaj Finserv';

    return 'Bank';
  }
}
