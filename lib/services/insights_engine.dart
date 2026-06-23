import 'package:uuid/uuid.dart';
import '../models/insight_card.dart';
import '../models/transaction.dart';
import '../models/app_settings.dart';
import '../models/budget.dart';
import '../models/project.dart';
import '../core/constants/app_constants.dart';

class InsightsEngine {
  Future<List<InsightCard>> generate({
    required List<Transaction> currentMonthTxns,
    required List<Transaction> lastMonthTxns,
    required List<Transaction> last3MonthsTxns,
    required List<Budget> budgets,
    required List<Project> projects,
    required AppSettings settings,
  }) async {
    final List<InsightCard> insights = [];
    final now = DateTime.now();

    void addInsight(InsightCard? card) {
      if (card != null) insights.add(card);
    }

    addInsight(_ruleSpendingSpike(currentMonthTxns, lastMonthTxns, now));
    addInsight(_ruleCategorySpike(currentMonthTxns, last3MonthsTxns, now));
    
    final budgetCards = _ruleBudgetStatus(currentMonthTxns, budgets, now);
    insights.addAll(budgetCards);
    
    addInsight(_ruleUnpaidProject(projects, currentMonthTxns, now));
    addInsight(_ruleRecurringDetected(currentMonthTxns, last3MonthsTxns, now));
    addInsight(_ruleIncomeTarget(currentMonthTxns, settings.monthlyIncomeTarget, now));
    addInsight(_ruleSavingsRate(currentMonthTxns, now));
    addInsight(_ruleTopMerchant(currentMonthTxns, now));
    addInsight(_ruleLowBalanceTrend(currentMonthTxns, budgets, now));

    return insights;
  }

  InsightCard? _ruleSpendingSpike(List<Transaction> current, List<Transaction> lastMonth, DateTime now) {
    double currentExp = current.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);
    double lastExp = lastMonth.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);
    
    if (lastExp > 0 && currentExp > lastExp * 1.25) {
      final diff = ((currentExp - lastExp) / lastExp * 100).toInt();
      return InsightCard(
        id: const Uuid().v4(),
        ruleId: 'spending_spike',
        type: InsightType.warning,
        headline: 'Spending Spike Detected',
        detail: 'Your spending is up $diff% compared to last month.',
        generatedAt: now,
        isDismissed: false,
      );
    }
    return null;
  }

  InsightCard? _ruleCategorySpike(List<Transaction> current, List<Transaction> last3, DateTime now) {
    // Calculate average per category over last 3 months
    Map<Category, double> avgSpends = {};
    for (var t in last3.where((t) => t.direction == TransactionDirection.debit)) {
      avgSpends[t.category] = (avgSpends[t.category] ?? 0) + t.amount;
    }
    avgSpends.forEach((k, v) => avgSpends[k] = v / 3);

    // Calculate current month per category
    Map<Category, double> currSpends = {};
    for (var t in current.where((t) => t.direction == TransactionDirection.debit)) {
      currSpends[t.category] = (currSpends[t.category] ?? 0) + t.amount;
    }

    for (var entry in currSpends.entries) {
      final cat = entry.key;
      final curr = entry.value;
      final avg = avgSpends[cat] ?? 0;
      
      if (avg > 0 && curr > avg * 1.40) {
        final diff = ((curr - avg) / avg * 100).toInt();
        return InsightCard(
          id: const Uuid().v4(),
          ruleId: 'category_spike_${cat.name}',
          type: InsightType.warning,
          headline: '${cat.name.toUpperCase()} Spike',
          detail: 'You spent $diff% more on ${cat.name} than your 3-month average.',
          generatedAt: now,
          isDismissed: false,
        );
      }
    }
    return null;
  }

  List<InsightCard> _ruleBudgetStatus(List<Transaction> current, List<Budget> budgets, DateTime now) {
    List<InsightCard> cards = [];
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysLeft = daysInMonth - now.day;

    for (var b in budgets) {
      double spent = current.where((t) => t.direction == TransactionDirection.debit && t.category == b.category).fold(0, (s, t) => s + t.amount);
      
      if (spent > b.monthlyLimit) {
        cards.add(InsightCard(
          id: const Uuid().v4(),
          ruleId: 'budget_exceeded_${b.category.name}',
          type: InsightType.danger,
          headline: 'Budget Exceeded',
          detail: '${b.category.name.toUpperCase()} budget exceeded by ₹${(spent - b.monthlyLimit).toStringAsFixed(0)}.',
          generatedAt: now,
          isDismissed: false,
        ));
      } else if (spent > b.monthlyLimit * 0.8 && daysLeft > 7) {
        cards.add(InsightCard(
          id: const Uuid().v4(),
          ruleId: 'budget_warning_${b.category.name}',
          type: InsightType.warning,
          headline: 'Budget Running Low',
          detail: '${b.category.name.toUpperCase()} budget is ${(spent / b.monthlyLimit * 100).toInt()}% used with $daysLeft days left.',
          generatedAt: now,
          isDismissed: false,
        ));
      }
    }
    return cards;
  }

  InsightCard? _ruleUnpaidProject(List<Project> projects, List<Transaction> txns, DateTime now) {
    for (var p in projects) {
      if (p.status == ProjectStatus.unpaid || p.status == ProjectStatus.completed) {
        // Find if there is any credit transaction linked to this project
        bool hasIncome = txns.any((t) => t.projectId == p.id && t.direction == TransactionDirection.credit);
        if (!hasIncome && p.deadline != null && now.difference(p.deadline!).inDays > 7) {
          return InsightCard(
            id: const Uuid().v4(),
            ruleId: 'unpaid_project_${p.id}',
            type: InsightType.warning,
            headline: 'Overdue Project',
            detail: 'Project "${p.name}" has been overdue for ${now.difference(p.deadline!).inDays} days.',
            generatedAt: now,
            isDismissed: false,
          );
        }
      }
    }
    return null;
  }

  InsightCard? _ruleRecurringDetected(List<Transaction> current, List<Transaction> last3, DateTime now) {
    // Very simple recurring detection based on merchant name and exact amounts
    Map<String, int> exactCharges = {};
    for (var t in last3.where((t) => t.direction == TransactionDirection.debit && t.merchantName != null)) {
      String key = '${t.merchantName!}_${t.amount}';
      exactCharges[key] = (exactCharges[key] ?? 0) + 1;
    }
    
    for (var entry in exactCharges.entries) {
      if (entry.value >= 3) {
        // Happened 3 times in last 3 months
        return InsightCard(
          id: const Uuid().v4(),
          ruleId: 'recurring_detected',
          type: InsightType.info,
          headline: 'Recurring Expense',
          detail: 'Detected possible subscription: ${entry.key.split('_')[0]} (₹${entry.key.split('_')[1]})',
          generatedAt: now,
          isDismissed: false,
        );
      }
    }
    return null;
  }

  InsightCard? _ruleIncomeTarget(List<Transaction> current, double target, DateTime now) {
    if (target <= 0) return null;
    double income = current.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
    
    if (income >= target) {
      return InsightCard(
        id: const Uuid().v4(),
        ruleId: 'income_target_reached',
        type: InsightType.success,
        headline: 'Target Reached! 🎉',
        detail: 'You have hit your monthly income target of ₹${target.toStringAsFixed(0)}.',
        generatedAt: now,
        isDismissed: false,
      );
    } else {
      int perc = (income / target * 100).toInt();
      return InsightCard(
        id: const Uuid().v4(),
        ruleId: 'income_target_progress',
        type: InsightType.info,
        headline: 'Income Goal: $perc%',
        detail: 'You are ₹${(target - income).toStringAsFixed(0)} away from your target.',
        generatedAt: now,
        isDismissed: false,
      );
    }
  }

  InsightCard? _ruleSavingsRate(List<Transaction> current, DateTime now) {
    double income = current.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
    double expense = current.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);
    
    if (income > 0) {
      int rate = ((income - expense) / income * 100).toInt();
      return InsightCard(
        id: const Uuid().v4(),
        ruleId: 'savings_rate',
        type: InsightType.info,
        headline: 'Savings Rate',
        detail: 'Your savings rate this month is $rate%.',
        generatedAt: now,
        isDismissed: false,
      );
    }
    return null;
  }

  InsightCard? _ruleTopMerchant(List<Transaction> current, DateTime now) {
    Map<String, double> merchantSpend = {};
    for (var t in current.where((t) => t.direction == TransactionDirection.debit && t.merchantName != null)) {
      merchantSpend[t.merchantName!] = (merchantSpend[t.merchantName!] ?? 0) + t.amount;
    }
    
    if (merchantSpend.isNotEmpty) {
      var top = merchantSpend.entries.reduce((a, b) => a.value > b.value ? a : b);
      return InsightCard(
        id: const Uuid().v4(),
        ruleId: 'top_merchant',
        type: InsightType.info,
        headline: 'Top Merchant',
        detail: 'You spent ₹${top.value.toStringAsFixed(0)} at ${top.key} this month.',
        generatedAt: now,
        isDismissed: false,
      );
    }
    return null;
  }

  InsightCard? _ruleLowBalanceTrend(List<Transaction> current, List<Budget> budgets, DateTime now) {
    // Placeholder logic for now
    return null;
  }
}