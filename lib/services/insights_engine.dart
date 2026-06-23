import '../models/insight_card.dart';
import '../models/transaction.dart';
import '../models/app_settings.dart';

class InsightsEngine {
  Future<List<InsightCard>> generate({
    required List<Transaction> transactions,
    required Map<String, double> budgets,
    required AppSettings settings,
  }) async {
    // PHASE 9: implement all 10 rules here
    return [];
  }
}