import 'dart:math';

/// A lightweight, purely Dart-native Naive Bayes Machine Learning Classifier.
/// It calculates the probabilistic likelihood that an SMS is a valid financial
/// transaction versus promotional spam.
class NaiveBayesClassifier {
  // Pre-calculated word frequencies from simulated training data
  static const Map<String, int> _spamFreq = {
    'loan': 20, 'limit': 15, 'offer': 25, 'apply': 15, 'kyc': 10, 'otp': 15,
    'code': 10, 'dear': 30, 'click': 20, 'http': 20, 'approval': 15,
    'congratulations': 10, 'reward': 15, 'voucher': 10, 'discount': 15,
    'instant': 10, 'personal': 10, 'fibe': 5, 'statement': 10, 'upload': 10,
    'wait': 5, 'yours': 5, 'today': 10, 't&c': 10, 'approved': 10,
  };

  static const Map<String, int> _validFreq = {
    'debited': 30, 'credited': 30, 'a/c': 20, 'ac': 20, 'account': 15,
    'ref': 15, 'upi': 40, 'imps': 10, 'neft': 5, 'rtgs': 5, 'trf': 10,
    'transfer': 15, 'available': 10, 'balance': 20, 'avl': 15, 'bal': 15,
    'amt': 10, 'amount': 10, 'spent': 10, 'paid': 20, 'sent': 15,
    'received': 15, 'deducted': 10, 'withdrawn': 10, 'inr': 30, 'rs': 30,
    'dt': 10, 'thru': 15,
  };

  static const int _totalSpamMessages = 100;
  static const int _totalValidMessages = 100;

  /// Returns a probability between 0.0 (Spam) and 1.0 (Valid Transaction)
  static double calculateTransactionProbability(String text) {
    final tokens = _tokenize(text);
    
    // Using log probabilities to avoid floating point underflow
    double logProbValid = log(_totalValidMessages / (_totalValidMessages + _totalSpamMessages));
    double logProbSpam = log(_totalSpamMessages / (_totalValidMessages + _totalSpamMessages));

    // Vocabulary sizes for Laplace Smoothing
    final int vocabSize = _spamFreq.length + _validFreq.length;
    
    final int totalSpamWords = _spamFreq.values.fold(0, (sum, val) => sum + val);
    final int totalValidWords = _validFreq.values.fold(0, (sum, val) => sum + val);

    for (final token in tokens) {
      // Laplace Smoothing (adds 1 to handle words never seen in training data)
      final int spamCount = _spamFreq[token] ?? 0;
      final int validCount = _validFreq[token] ?? 0;

      final double pTokenGivenSpam = (spamCount + 1) / (totalSpamWords + vocabSize);
      final double pTokenGivenValid = (validCount + 1) / (totalValidWords + vocabSize);

      logProbSpam += log(pTokenGivenSpam);
      logProbValid += log(pTokenGivenValid);
    }

    // Convert back from log-space to a percentage (0.0 to 1.0)
    // P(Valid|Text) = exp(logProbValid) / (exp(logProbValid) + exp(logProbSpam))
    // We use a math trick to prevent overflow during exp()
    final double maxLog = max(logProbValid, logProbSpam);
    final double probValid = exp(logProbValid - maxLog) / (exp(logProbValid - maxLog) + exp(logProbSpam - maxLog));

    return probValid;
  }

  /// Breaks the text into normalized, lowercased words
  static List<String> _tokenize(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s/]'), ' ');
    return cleanText.split(RegExp(r'\s+')).where((t) => t.trim().isNotEmpty).toList();
  }
}
