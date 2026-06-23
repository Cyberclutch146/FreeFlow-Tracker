import '../models/transaction.dart';
import '../core/constants/app_constants.dart';

class SubscriptionSuggestion {
  final String merchantName;
  final double amount;
  final List<Transaction> matchingTransactions;

  SubscriptionSuggestion({
    required this.merchantName,
    required this.amount,
    required this.matchingTransactions,
  });
}

class SubscriptionScannerService {
  static List<SubscriptionSuggestion> findPotentialSubscriptions(List<Transaction> transactions) {
    // Only look at debit transactions that are NOT already subscriptions
    final expenses = transactions.where((t) => 
      t.direction == TransactionDirection.debit && 
      t.category != Category.subscriptions
    ).toList();

    // Group by merchant name or note
    final Map<String, List<Transaction>> grouped = {};
    for (var t in expenses) {
      final key = t.merchantName ?? t.note ?? 'Unknown';
      if (key == 'Unknown') continue;
      
      grouped.putIfAbsent(key, () => []).add(t);
    }

    final List<SubscriptionSuggestion> suggestions = [];

    for (var entry in grouped.entries) {
      final txns = entry.value;
      if (txns.length < 2) continue; // Need at least 2 to detect a pattern

      // Sort chronologically
      txns.sort((a, b) => a.date.compareTo(b.date));

      // Check if amounts are similar and dates are ~1 month apart
      bool isRecurring = true;
      double baseAmount = txns.first.amount;

      for (int i = 1; i < txns.length; i++) {
        final prev = txns[i - 1];
        final curr = txns[i];

        // Amounts must be within 10%
        final diff = (curr.amount - baseAmount).abs();
        if (diff > (baseAmount * 0.1)) {
          isRecurring = false;
          break;
        }

        // Dates should be ~25-35 days apart
        final daysApart = curr.date.difference(prev.date).inDays.abs();
        if (daysApart < 25 || daysApart > 35) {
          isRecurring = false;
          break;
        }
      }

      if (isRecurring) {
        suggestions.add(SubscriptionSuggestion(
          merchantName: entry.key,
          amount: baseAmount,
          matchingTransactions: txns,
        ));
      }
    }

    return suggestions;
  }
}
