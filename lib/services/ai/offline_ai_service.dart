import 'dart:math';
import '../../models/transaction.dart';
import '../../models/savings_goal.dart';
import '../../models/budget.dart';
import '../../models/app_settings.dart';
import '../../core/constants/app_constants.dart';
import 'category_classifier.dart';

/// Offline conversational AI engine. No API key, no internet, instant responses.
///
/// Features:
/// - Persistent conversation history within a session (call [resetChat] to clear)
/// - Follow-up detection: remembers what was asked last and routes accordingly
/// - Progressive verbosity: early turns give compact answers, later turns expand
/// - Error-safe: chat() never throws; falls back to a friendly message
class OfflineAIService {
  final _random = Random();

  // ── Conversation state ────────────────────────────────────────────────────
  final List<_ChatTurn> _history = [];
  String? _lastIntent;    // Intent of the previous turn (for follow-up routing)
  int _turnCount = 0;     // Total turns in the current session

  // Always "configured" — no API key needed
  bool get isConfigured => true;

  /// Returns a read-only summary of the conversation so far (last N turns).
  List<String> get conversationSummary {
    final recent = _history.length > 6
        ? _history.sublist(_history.length - 6)
        : _history;
    return recent.map((t) => '[${t.role}]: ${t.text}').toList();
  }

  void resetChat() {
    _history.clear();
    _lastIntent = null;
    _turnCount = 0;
  }

  // ── 1. Conversational Chat ────────────────────────────────────────────────

  Future<String> chat(
    String userMessage, {
    required List<Transaction> recentTransactions,
    required List<SavingsGoal> goals,
    required List<Budget> budgets,
    required AppSettings? settings,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 350 + _random.nextInt(400)));

      final now = DateTime.now();

      // Fix: explicit previous-month calculation handles January correctly
      final prevMonthDate = now.month == 1
          ? DateTime(now.year - 1, 12)
          : DateTime(now.year, now.month - 1);

      final thisMonth = recentTransactions
          .where((t) => t.date.year == now.year && t.date.month == now.month)
          .toList();
      final lastMonth = recentTransactions
          .where((t) =>
              t.date.year == prevMonthDate.year &&
              t.date.month == prevMonthDate.month)
          .toList();

      final ctx = _FinancialContext.build(
        thisMonth: thisMonth,
        lastMonth: lastMonth,
        allTransactions: recentTransactions,
        goals: goals,
        budgets: budgets,
        settings: settings,
        now: now,
      );

      _history.add(_ChatTurn(role: 'user', text: userMessage));
      _turnCount++;

      final lower = userMessage.toLowerCase();
      final intent = _classifyIntent(lower);

      // Follow-up detection: check if user is asking for more detail on last topic
      final isFollowUp = _isFollowUp(lower, _lastIntent);
      final response = isFollowUp
          ? _handleFollowUp(_lastIntent!, ctx)
          : _dispatch(intent, userMessage, ctx);

      _history.add(_ChatTurn(role: 'ai', text: response));
      _lastIntent = isFollowUp ? _lastIntent : intent;

      return response;
    } catch (e) {
      // Graceful fallback — never crash the chat screen
      return '⚠️ Something went wrong on my end! Try rephrasing or ask me a different question. (Error: ${e.runtimeType})';
    }
  }

  /// Returns true if the user's message is a follow-up on the [previousIntent].
  bool _isFollowUp(String lower, String? previousIntent) {
    if (previousIntent == null || previousIntent == 'greeting') return false;
    const followUpSignals = [
      'and', 'what about', 'also', 'tell me more', 'more detail',
      'explain', 'elaborate', 'break it down', 'break down', 'specifically',
      'last month', 'and last', 'show more', 'go on',
    ];
    return followUpSignals.any((s) => lower.startsWith(s) || lower.contains(s));
  }

  /// Provides a deeper, more detailed response for a follow-up turn.
  String _handleFollowUp(String previousIntent, _FinancialContext ctx) {
    switch (previousIntent) {
      case 'monthly_summary':
        return _handleCategoryBreakdown(ctx);
      case 'top_expenses':
        return _handleSpendingTrend(ctx);
      case 'budget_check':
        return _handleSavingsAdvice(ctx);
      case 'income_status':
        return _handleGoalProgress(ctx);
      case 'spending_trend':
        return _handlePrediction(ctx);
      default:
        return _handleMonthlySummary(ctx);
    }
  }

  // ──────────────────────────────────────────────
  // 2. Monthly Report
  // ──────────────────────────────────────────────

  Future<String> generateMonthlyReport({
    required List<Transaction> currentMonthTxns,
    required List<Transaction> lastMonthTxns,
    required List<SavingsGoal> goals,
    required List<Budget> budgets,
    required AppSettings settings,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();
    final ctx = _FinancialContext.build(
      thisMonth: currentMonthTxns,
      lastMonth: lastMonthTxns,
      allTransactions: [...currentMonthTxns, ...lastMonthTxns],
      goals: goals,
      budgets: budgets,
      settings: settings,
      now: now,
    );

    return _buildMonthlyReport(ctx, now);
  }

  // ──────────────────────────────────────────────
  // 3. Batch Categorization
  // ──────────────────────────────────────────────

  Future<Map<String, String>> batchCategorize(List<String> merchantNames) async {
    // batchClassifyNamed returns Map<String, String> (category.name strings), matching return type
    return CategoryClassifier.batchClassifyNamed(merchantNames);
  }

  // ──────────────────────────────────────────────
  // 4. Quick Insight
  // ──────────────────────────────────────────────

  Future<String> getQuickInsight({
    required List<Transaction> transactions,
    required String question,
    List<SavingsGoal> goals = const [],
    List<Budget> budgets = const [],
    AppSettings? settings,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final intent = _classifyIntent(question.toLowerCase());
    final now = DateTime.now();

    // Fix: explicit previous-month calc handles January correctly
    final prevMonthDate = now.month == 1
        ? DateTime(now.year - 1, 12)
        : DateTime(now.year, now.month - 1);

    final thisMonth = transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .toList();
    final lastMonth = transactions
        .where((t) =>
            t.date.year == prevMonthDate.year &&
            t.date.month == prevMonthDate.month)
        .toList();

    final ctx = _FinancialContext.build(
      thisMonth: thisMonth,
      lastMonth: lastMonth,
      allTransactions: transactions,
      goals: goals,
      budgets: budgets,
      settings: settings,
      now: now,
    );
    return _dispatch(intent, question, ctx);
  }

  // ──────────────────────────────────────────────
  // Intent Classification (12 intents)
  // ──────────────────────────────────────────────

  static const _intentPatterns = <String, List<String>>{
    'greeting': ['hi', 'hello', 'hey', 'good morning', 'good evening', 'thanks', 'thank you', 'great', 'awesome', 'nice'],
    'monthly_summary': ['how am i doing', 'how am i', 'doing this month', 'this month', 'overview', 'summary', 'overall', 'give me a summary', 'quick update'],
    'top_expenses': ['top expense', 'where is my money', 'where does my money', 'biggest spend', 'most spent', 'what am i spending', 'spending on', 'biggest expense', 'where money going'],
    'budget_check': ['budget', 'limit', 'over budget', 'budget check', 'budget status', 'budget left', 'how much left', 'remaining budget'],
    'savings_advice': ['save more', 'cut back', 'reduce', 'how can i save', 'saving tips', 'ways to save', 'spend less', 'savings advice', 'saving advice', 'help me save'],
    'income_status': ['income', 'earned', 'how much did i earn', 'revenue', 'income target', 'target', 'how close am i', 'earnings'],
    'goal_progress': ['goal', 'savings goal', 'progress', 'how far', 'how long', 'when will i reach', 'goal status'],
    'spending_trend': ['trend', 'compare', 'vs last month', 'compared to', 'last month', 'difference', 'month over month', 'changed'],
    'category_breakdown': ['category', 'breakdown', 'categories', 'food spending', 'transport spending', 'what categories'],
    'recurring_check': ['subscription', 'recurring', 'auto pay', 'auto-pay', 'regular payment', 'monthly charge', 'auto debit'],
    'daily_average': ['daily', 'average', 'per day', 'day by day', 'average spending'],
    'prediction': ['predict', 'projection', 'end of month', 'will i', 'if i continue', 'at this rate', 'how much will'],
  };

  String _classifyIntent(String message) {
    int bestScore = 0;
    String bestIntent = 'unknown';

    for (final entry in _intentPatterns.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          final score = keyword.length;
          if (score > bestScore) {
            bestScore = score;
            bestIntent = entry.key;
          }
        }
      }
    }
    return bestIntent;
  }

  // ──────────────────────────────────────────────
  // Intent Dispatcher
  // ──────────────────────────────────────────────

  String _dispatch(String intent, String userMessage, _FinancialContext ctx) {
    switch (intent) {
      case 'greeting': return _handleGreeting(ctx);
      case 'monthly_summary': return _handleMonthlySummary(ctx);
      case 'top_expenses': return _handleTopExpenses(ctx);
      case 'budget_check': return _handleBudgetCheck(ctx);
      case 'savings_advice': return _handleSavingsAdvice(ctx);
      case 'income_status': return _handleIncomeStatus(ctx);
      case 'goal_progress': return _handleGoalProgress(ctx);
      case 'spending_trend': return _handleSpendingTrend(ctx);
      case 'category_breakdown': return _handleCategoryBreakdown(ctx);
      case 'recurring_check': return _handleRecurringCheck(ctx);
      case 'daily_average': return _handleDailyAverage(ctx);
      case 'prediction': return _handlePrediction(ctx);
      default: return _handleUnknown(userMessage);
    }
  }

  // ──────────────────────────────────────────────
  // Response Handlers — each with multiple variations
  // ──────────────────────────────────────────────

  String _handleGreeting(_FinancialContext ctx) {
    final greetings = [
      '👋 Hey! I\'m your personal finance assistant, always ready to dig into the numbers!\n\nTry asking me:\n• "How am I doing this month?"\n• "Where is my money going?"\n• "Give me a budget check"\n• "How can I save more?"',
      '💰 Hi there! Your financial data is loaded and I\'m ready to help.\n\nSome things you can ask:\n• Monthly summary\n• Top expenses\n• Goal progress\n• Spending trends',
      '🤖 Hey! Ask me anything about your finances — budgets, goals, spending habits, you name it!\n\nI\'m working with your real data, so my answers are always accurate.',
    ];
    return _pick(greetings);
  }

  String _handleMonthlySummary(_FinancialContext ctx) {
    final net = ctx.income - ctx.expense;
    final savingsRate = ctx.income > 0 ? (net / ctx.income * 100).toInt() : 0;
    final netEmoji = net >= 0 ? '✅' : '⚠️';
    final netWord = net >= 0 ? 'surplus' : 'deficit';

    final topCategoryLine = ctx.topCategory != null
        ? '\n🏆 Biggest spend: **${_formatCategory(ctx.topCategory!.key)}** at ₹${ctx.topCategory!.value.toStringAsFixed(0)}'
        : '';

    final budgetAlert = ctx.overBudgetCategories.isNotEmpty
        ? '\n🚨 You\'ve exceeded your budget in: ${ctx.overBudgetCategories.map(_formatCategory).join(', ')}'
        : '';

    final templates = [
      '''📊 **Monthly Snapshot — ${_monthName(ctx.now)}**

💰 Income: ₹${ctx.income.toStringAsFixed(0)}
💸 Expenses: ₹${ctx.expense.toStringAsFixed(0)}
$netEmoji Net: ₹${net.abs().toStringAsFixed(0)} $netWord ($savingsRate% savings rate)$topCategoryLine$budgetAlert

${_motivationalClose(savingsRate, net)}''',

      '''🔍 **Quick Check-In — ${_monthName(ctx.now)}**

You've earned ₹${ctx.income.toStringAsFixed(0)} and spent ₹${ctx.expense.toStringAsFixed(0)} this month.
That leaves you with ₹${net.abs().toStringAsFixed(0)} ${net >= 0 ? 'in the green 💚' : 'in the red 🔴'}!

📈 Savings rate: $savingsRate%$topCategoryLine$budgetAlert

${_savingsRateComment(savingsRate)}''',

      '''**Hey, here's where things stand this month:**

• Earned: ₹${ctx.income.toStringAsFixed(0)}
• Spent: ₹${ctx.expense.toStringAsFixed(0)}
• Net: ${net >= 0 ? '+' : '-'}₹${net.abs().toStringAsFixed(0)} ($savingsRate% savings rate)$topCategoryLine$budgetAlert

${_motivationalClose(savingsRate, net)}''',
    ];
    return _pick(templates);
  }

  String _handleTopExpenses(_FinancialContext ctx) {
    if (ctx.categoryBreakdown.isEmpty) {
      return '🤔 You don\'t have any expense transactions this month yet. Start adding some and I\'ll track them for you!';
    }

    final sorted = ctx.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topItems = sorted.take(5).map((e) {
      final pct = ctx.expense > 0 ? (e.value / ctx.expense * 100).toInt() : 0;
      final bar = _progressBar(pct, 100, 8);
      return '$bar **${_formatCategory(e.key)}**: ₹${e.value.toStringAsFixed(0)} ($pct%)';
    }).join('\n');

    final merchantLine = ctx.topMerchant != null
        ? '\n\n🏪 Top merchant: **${ctx.topMerchant!.key}** — ₹${ctx.topMerchant!.value.toStringAsFixed(0)}'
        : '';

    final templates = [
      '''💸 **Where Your Money\'s Going — ${_monthName(ctx.now)}**

$topItems$merchantLine

Total expenses: ₹${ctx.expense.toStringAsFixed(0)}''',

      '''🔎 **Spending Breakdown**

Here's what's eating into your budget this month:

$topItems$merchantLine''',
    ];
    return _pick(templates);
  }

  String _handleBudgetCheck(_FinancialContext ctx) {
    if (ctx.budgets.isEmpty) {
      return '📋 You haven\'t set any budgets yet! Head to the **Budgets** section and set monthly limits for your spending categories. It\'s one of the best ways to stay in control 💪';
    }

    final lines = ctx.budgets.map((b) {
      final spent = ctx.categoryBreakdown[b.category] ?? 0;
      final pct = b.monthlyLimit > 0 ? (spent / b.monthlyLimit * 100).toInt() : 0;
      final bar = _progressBar(pct, 100, 10);
      final status = pct > 100 ? '🚨 OVER' : pct > 80 ? '⚠️ CLOSE' : '✅ OK';
      return '$bar **${_formatCategory(b.category)}**: ₹${spent.toStringAsFixed(0)}/₹${b.monthlyLimit.toStringAsFixed(0)} ($pct%) $status';
    }).join('\n');

    final overCount = ctx.overBudgetCategories.length;
    final summary = overCount > 0
        ? '⚠️ You\'ve exceeded $overCount budget${overCount > 1 ? 's' : ''} this month. Time to tighten up!'
        : '🎉 All budgets are in check! Keep it up.';

    return '''📋 **Budget Status — ${_monthName(ctx.now)}**

$lines

$summary''';
  }

  String _handleSavingsAdvice(_FinancialContext ctx) {
    final tips = <String>[];

    // Category-based tips
    if (ctx.categoryBreakdown.containsKey(Category.food) && ctx.expense > 0) {
      final foodPct = (ctx.categoryBreakdown[Category.food]! / ctx.expense * 100).toInt();
      if (foodPct > 30) {
        tips.add('🍽️ **Food & Dining** is eating up $foodPct% of your expenses. Try meal prepping 2-3 days a week — it can cut costs by 30-40%!');
      }
    }

    if (ctx.categoryBreakdown.containsKey(Category.entertainment)) {
      final amt = ctx.categoryBreakdown[Category.entertainment]!;
      if (amt > 1000) {
        tips.add('🎬 You\'ve spent ₹${amt.toStringAsFixed(0)} on entertainment. Audit your streaming subscriptions — you might be paying for ones you barely use.');
      }
    }

    if (ctx.categoryBreakdown.containsKey(Category.subscriptions)) {
      final amt = ctx.categoryBreakdown[Category.subscriptions]!;
      tips.add('📱 ₹${amt.toStringAsFixed(0)} in subscriptions this month. Do a quick audit — cancel anything you haven\'t used in the last 30 days.');
    }

    // Savings rate tips
    final savingsRate = ctx.income > 0 ? ((ctx.income - ctx.expense) / ctx.income * 100).toInt() : 0;
    if (savingsRate < 20 && ctx.income > 0) {
      tips.add('💡 Your savings rate is $savingsRate%. Most financial advisors recommend saving at least 20% of income. Even saving ₹${(ctx.income * 0.05).toStringAsFixed(0)} more per month adds up over time!');
    }

    // Generic high-value tips
    final genericTips = [
      '🏦 Automate your savings — set aside a fixed amount the day your income arrives, before you can spend it.',
      '📊 Track every expense for one week. Most people discover 2-3 categories where they\'re unconsciously overspending.',
      '🎯 Use the 24-hour rule for purchases over ₹1,000 — wait a day before buying. You\'ll skip about 30% of impulse buys.',
      '☕ Small recurring costs add up fast. That ₹150 coffee every day is ₹4,500/month — almost ₹54,000/year!',
    ];

    if (tips.isEmpty) {
      // Fix: shuffle then take 2 to guarantee no duplicates
      final shuffled = List<String>.from(genericTips)..shuffle(_random);
      tips.addAll(shuffled.take(2));
    }

    final header = _pick([
      '💡 **Savings Tips Just For You**\n\nBased on your spending patterns, here\'s what I\'d focus on:\n',
      '🎯 **How to Save More This Month**\n\nHere are some personalized suggestions:\n',
      '💰 **Smart Savings Moves**\n\nLooking at your data, here\'s my advice:\n',
    ]);

    return '$header${tips.take(3).join('\n\n')}';
  }

  String _handleIncomeStatus(_FinancialContext ctx) {
    final target = ctx.settings?.monthlyIncomeTarget ?? 0;
    final remaining = target - ctx.income;
    final pct = target > 0 ? (ctx.income / target * 100).toInt() : 0;

    if (target <= 0) {
      return '💰 You\'ve earned **₹${ctx.income.toStringAsFixed(0)}** this month!\n\nTip: Set a monthly income target in Settings to track your progress against a goal.';
    }

    final bar = _progressBar(pct, 100, 12);

    if (ctx.income >= target) {
      return '''🎉 **Income Target: ACHIEVED!**

$bar $pct%

You\'ve earned ₹${ctx.income.toStringAsFixed(0)}, surpassing your ₹${target.toStringAsFixed(0)} target by ₹${(ctx.income - target).toStringAsFixed(0)}!

${_pick(['Amazing work! 🔥 Consider putting that extra income towards your savings goals.', 'Crushing it! 💪 That surplus of ₹${(ctx.income - target).toStringAsFixed(0)} could go straight into a savings goal.'])}''';
    }

    final daysInMonth = DateTime(ctx.now.year, ctx.now.month + 1, 0).day;
    final daysLeft = daysInMonth - ctx.now.day;
    final dailyNeeded = daysLeft > 0 ? remaining / daysLeft : remaining;

    return '''💰 **Income Status — ${_monthName(ctx.now)}**

$bar $pct%

Earned: ₹${ctx.income.toStringAsFixed(0)} / ₹${target.toStringAsFixed(0)} target
Remaining: ₹${remaining.toStringAsFixed(0)} in $daysLeft days
Daily needed: ₹${dailyNeeded.toStringAsFixed(0)}/day

${pct >= 75 ? '🔥 Almost there! Keep pushing!' : pct >= 50 ? '💪 Halfway through — good pace!' : '📈 Room to grow. Focus on landing that next project or invoice!'}''';
  }

  String _handleGoalProgress(_FinancialContext ctx) {
    final active = ctx.goals.where((g) => g.status == GoalStatus.active).toList();

    if (active.isEmpty) {
      return '🎯 No active savings goals yet!\n\nHead to the **Goals** tab and create one. Whether it\'s a laptop, an emergency fund, or a vacation — having a goal makes saving feel purposeful!';
    }

    final goalLines = active.take(4).map((g) {
      final pct = g.targetAmount > 0 ? (g.currentAmount / g.targetAmount * 100).toInt() : 0;
      final bar = _progressBar(pct, 100, 10);
      final deadlineNote = g.deadline != null
          ? ' • Due ${_formatDate(g.deadline!)}'
          : '';
      final monthsLeft = g.monthlyAllocation > 0
          ? ((g.targetAmount - g.currentAmount) / g.monthlyAllocation).ceil()
          : null;
      final etaNote = monthsLeft != null && monthsLeft > 0
          ? ' (~$monthsLeft months at current pace)'
          : '';
      return '${g.emoji} **${g.name}**\n$bar $pct% — ₹${g.currentAmount.toStringAsFixed(0)}/₹${g.targetAmount.toStringAsFixed(0)}$deadlineNote$etaNote';
    }).join('\n\n');

    return '''🎯 **Savings Goal Progress**

$goalLines

${active.length > 4 ? '\n...and ${active.length - 4} more goals.' : ''}

${_pick(['Keep going! Every rupee counts. 💪', 'Slow and steady wins the race! 🏆', 'You\'re making real progress! Keep it up. 🚀'])}''';
  }

  String _handleSpendingTrend(_FinancialContext ctx) {
    if (ctx.lastExpense == 0 && ctx.lastIncome == 0) {
      return '📈 I don\'t have enough data for last month yet. Keep using the app and I\'ll have a comparison ready next month!';
    }

    final expDiff = ctx.lastExpense > 0 ? ((ctx.expense - ctx.lastExpense) / ctx.lastExpense * 100).toInt() : 0;
    final incDiff = ctx.lastIncome > 0 ? ((ctx.income - ctx.lastIncome) / ctx.lastIncome * 100).toInt() : 0;

    final expArrow = expDiff > 0 ? '⬆️' : '⬇️';
    final incArrow = incDiff > 0 ? '⬆️' : '⬇️';
    final expColor = expDiff > 10 ? '🔴' : expDiff < -10 ? '🟢' : '🟡';
    final incColor = incDiff >= 0 ? '🟢' : '🔴';

    final analysis = _getTrendAnalysis(expDiff, incDiff);

    return '''📈 **Month-over-Month Trend**

💸 **Expenses**: ₹${ctx.expense.toStringAsFixed(0)} vs ₹${ctx.lastExpense.toStringAsFixed(0)} last month
$expColor $expArrow ${expDiff.abs()}% ${expDiff > 0 ? 'more' : 'less'} spending

💰 **Income**: ₹${ctx.income.toStringAsFixed(0)} vs ₹${ctx.lastIncome.toStringAsFixed(0)} last month
$incColor $incArrow ${incDiff.abs()}% ${incDiff > 0 ? 'increase' : 'decrease'}

💡 $analysis''';
  }

  String _handleCategoryBreakdown(_FinancialContext ctx) {
    if (ctx.categoryBreakdown.isEmpty) {
      return '📊 No expense data this month yet. Start recording transactions and I\'ll show you a full breakdown!';
    }

    final sorted = ctx.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final lines = sorted.map((e) {
      final pct = ctx.expense > 0 ? (e.value / ctx.expense * 100).toInt() : 0;
      final bar = _progressBar(pct, 100, 8);
      return '$bar ${_formatCategory(e.key)} — ₹${e.value.toStringAsFixed(0)} ($pct%)';
    }).join('\n');

    return '''📊 **Category Breakdown — ${_monthName(ctx.now)}**

$lines

Total: ₹${ctx.expense.toStringAsFixed(0)}

${ctx.topCategory != null ? '🏆 **${_formatCategory(ctx.topCategory!.key)}** is your biggest expense category this month.' : ''}''';
  }

  String _handleRecurringCheck(_FinancialContext ctx) {
    final subAmount = ctx.categoryBreakdown[Category.subscriptions] ?? 0;

    if (subAmount == 0) {
      return '📱 No subscription expenses detected this month yet. Once you log them, I\'ll help you keep track of recurring charges!';
    }

    return '''📱 **Recurring & Subscriptions**

You\'ve spent **₹${subAmount.toStringAsFixed(0)}** on subscriptions this month.

${subAmount > 2000 ? '⚠️ That\'s a sizeable chunk! Here\'s a tip: audit every subscription and ask "have I used this in the past 30 days?" Cancel anything that\'s a "no".' : '✅ Subscription spending looks reasonable.'}

💡 **Quick audit checklist:**
• Streaming: Netflix, Prime, Hotstar, Spotify
• Tools: Notion, Figma, Adobe, Canva
• Cloud: Google One, iCloud, Dropbox
• News & Learning: Udemy, Coursera

Go through each one — you might find ₹500-₹1,000 you can cut!''';
  }

  String _handleDailyAverage(_FinancialContext ctx) {
    final daysElapsed = ctx.now.day;
    final dailyAvg = daysElapsed > 0 ? ctx.expense / daysElapsed : 0.0;

    final daysInMonth = DateTime(ctx.now.year, ctx.now.month + 1, 0).day;
    final projectedMonthly = dailyAvg * daysInMonth;

    return '''📅 **Daily Spending Average**

Days elapsed: $daysElapsed / $daysInMonth
Daily average: **₹${dailyAvg.toStringAsFixed(0)}/day**
Total so far: ₹${ctx.expense.toStringAsFixed(0)}

📊 At this rate, you\'ll end the month at about **₹${projectedMonthly.toStringAsFixed(0)}** in expenses.

${ctx.income > 0 ? (projectedMonthly < ctx.income ? '✅ That\'s comfortably within your income — great!' : '⚠️ That exceeds your current income of ₹${ctx.income.toStringAsFixed(0)}. Consider pulling back a bit.') : ''}''';
  }

  String _handlePrediction(_FinancialContext ctx) {
    final daysElapsed = max(1, ctx.now.day);
    final daysInMonth = DateTime(ctx.now.year, ctx.now.month + 1, 0).day;
    final dailyExpRate = ctx.expense / daysElapsed;
    final dailyIncRate = ctx.income / daysElapsed;
    final projExpense = dailyExpRate * daysInMonth;
    final projIncome = dailyIncRate * daysInMonth;
    final projNet = projIncome - projExpense;
    final projSavingsRate = projIncome > 0 ? (projNet / projIncome * 100).toInt() : 0;

    final outlook = projNet > 0
        ? '📈 You\'re on track for a **positive month** with ₹${projNet.toStringAsFixed(0)} in savings!'
        : '⚠️ At this rate, you\'re heading for a ₹${projNet.abs().toStringAsFixed(0)} **deficit** by month end. Try cutting back on non-essentials this week.';

    return '''🔮 **End-of-Month Projection**

Based on ${ctx.now.day} days of data:

📊 Projected expenses: **₹${projExpense.toStringAsFixed(0)}**
💰 Projected income: **₹${projIncome.toStringAsFixed(0)}**
${projNet >= 0 ? '✅' : '⚠️'} Projected net: **₹${projNet.toStringAsFixed(0)}** ($projSavingsRate% savings rate)

$outlook

💡 Tip: These numbers are based on your current daily pace. A single big transaction can shift things significantly!''';
  }

  String _handleUnknown(String message) {
    final responses = [
      '🤔 Hmm, I\'m not sure I caught that. I\'m best at helping with:\n\n• Monthly summary\n• Budget status\n• Top expenses\n• Savings advice\n• Goal progress\n• Spending trends\n\nTry rephrasing your question!',
      '💭 I didn\'t quite understand that one! Ask me something like:\n• "How am I doing this month?"\n• "Give me a budget check"\n• "Where is my money going?"\n• "Show my goal progress"',
      '🤖 I\'m an offline finance assistant, so I work best with finance-related questions! Try:\n• "How can I save more?"\n• "Compare to last month"\n• "What are my top expenses?"',
    ];
    return _pick(responses);
  }

  // ──────────────────────────────────────────────
  // Monthly Report Builder
  // ──────────────────────────────────────────────

  String _buildMonthlyReport(_FinancialContext ctx, DateTime now) {
    final net = ctx.income - ctx.expense;
    final savingsRate = ctx.income > 0 ? (net / ctx.income * 100).toInt() : 0;
    final expDiff = ctx.lastExpense > 0 ? ((ctx.expense - ctx.lastExpense) / ctx.lastExpense * 100).toInt() : 0;
    final incDiff = ctx.lastIncome > 0 ? ((ctx.income - ctx.lastIncome) / ctx.lastIncome * 100).toInt() : 0;

    // Section 1: Header & Summary
    final header = '''# 📊 Financial Report — ${_monthName(now)} ${now.year}

## 💼 Overview
| | Amount |
|---|---|
| 💰 Income | ₹${ctx.income.toStringAsFixed(0)} |
| 💸 Expenses | ₹${ctx.expense.toStringAsFixed(0)} |
| ${net >= 0 ? '✅' : '⚠️'} Net Balance | ₹${net.toStringAsFixed(0)} |
| 📈 Savings Rate | $savingsRate% |
''';

    // Section 2: vs Last Month
    final vsLastMonth = ctx.lastIncome > 0 || ctx.lastExpense > 0 ? '''
## 📈 vs. Last Month
• Income: ${incDiff >= 0 ? '⬆️' : '⬇️'} ${incDiff.abs()}% (₹${ctx.lastIncome.toStringAsFixed(0)} → ₹${ctx.income.toStringAsFixed(0)})
• Expenses: ${expDiff > 0 ? '⬆️' : '⬇️'} ${expDiff.abs()}% (₹${ctx.lastExpense.toStringAsFixed(0)} → ₹${ctx.expense.toStringAsFixed(0)})
• ${_getTrendAnalysis(expDiff, incDiff)}
''' : '';

    // Section 3: Category Breakdown
    final sorted = ctx.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final categoryLines = sorted.take(6).map((e) {
      final pct = ctx.expense > 0 ? (e.value / ctx.expense * 100).toInt() : 0;
      final bar = _progressBar(pct, 100, 10);
      return '$bar **${_formatCategory(e.key)}**: ₹${e.value.toStringAsFixed(0)} ($pct%)';
    }).join('\n');

    final categorySection = sorted.isNotEmpty ? '''
## 🗂️ Spending by Category
$categoryLines
''' : '';

    // Section 4: Top Merchants
    final merchantSection = ctx.merchantBreakdown.isNotEmpty ? () {
      final sortedMerchants = ctx.merchantBreakdown.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final lines = sortedMerchants.take(5).map((e) =>
        '• **${e.key}**: ₹${e.value.toStringAsFixed(0)}').join('\n');
      return '''
## 🏪 Top Merchants
$lines
''';
    }() : '';

    // Section 5: Budget Status
    final budgetSection = ctx.budgets.isNotEmpty ? () {
      final lines = ctx.budgets.map((b) {
        final spent = ctx.categoryBreakdown[b.category] ?? 0;
        final pct = b.monthlyLimit > 0 ? (spent / b.monthlyLimit * 100).toInt() : 0;
        final bar = _progressBar(pct, 100, 8);
        final status = pct > 100 ? '🚨' : pct > 80 ? '⚠️' : '✅';
        return '$bar $status **${_formatCategory(b.category)}**: ₹${spent.toStringAsFixed(0)}/₹${b.monthlyLimit.toStringAsFixed(0)} ($pct%)';
      }).join('\n');
      return '''
## 📋 Budget Status
$lines
''';
    }() : '';

    // Section 6: Goals
    final activeGoals = ctx.goals.where((g) => g.status == GoalStatus.active).toList();
    final goalSection = activeGoals.isNotEmpty ? () {
      final lines = activeGoals.take(4).map((g) {
        final pct = g.targetAmount > 0 ? (g.currentAmount / g.targetAmount * 100).toInt() : 0;
        final bar = _progressBar(pct, 100, 8);
        return '$bar ${g.emoji} **${g.name}**: ₹${g.currentAmount.toStringAsFixed(0)}/₹${g.targetAmount.toStringAsFixed(0)} ($pct%)';
      }).join('\n');
      return '''
## 🎯 Savings Goals
$lines
''';
    }() : '';

    // Section 7: Smart Tips
    final tips = _generateSmartTips(ctx, savingsRate, expDiff);
    final tipsSection = tips.isNotEmpty ? '''
## 💡 Smart Tips
${tips.map((t) => '• $t').join('\n')}
''' : '';

    // Closing
    final closing = '''
---
*Report generated offline • Always accurate • No cloud needed* 🔒''';

    return '$header$vsLastMonth$categorySection$merchantSection$budgetSection$goalSection$tipsSection$closing';
  }

  List<String> _generateSmartTips(_FinancialContext ctx, int savingsRate, int expDiff) {
    final tips = <String>[];

    if (savingsRate < 10 && ctx.income > 0) {
      tips.add('Your savings rate is $savingsRate%. Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings.');
    }
    if (expDiff > 20) {
      tips.add('Expenses jumped ${expDiff}% vs last month. Review what changed and identify the biggest drivers.');
    }
    if (ctx.categoryBreakdown.containsKey(Category.subscriptions)) {
      final subAmt = ctx.categoryBreakdown[Category.subscriptions]!;
      if (subAmt > 1500) {
        tips.add('₹${subAmt.toStringAsFixed(0)} in subscriptions. Audit and cancel unused ones to reclaim cash.');
      }
    }
    if (ctx.overBudgetCategories.isNotEmpty) {
      tips.add('You exceeded your budget in ${ctx.overBudgetCategories.map(_formatCategory).join(' & ')}. Consider raising the limit or reducing spending next month.');
    }
    if (ctx.goals.any((g) => g.status == GoalStatus.active) && savingsRate > 20) {
      tips.add('Great savings rate! Consider increasing your monthly goal allocation to hit targets faster.');
    }
    if (tips.isEmpty) {
      tips.add('You\'re in good shape! Keep tracking expenses consistently for the best insights.');
    }
    return tips.take(3).toList();
  }

  // ──────────────────────────────────────────────
  // Helper Utilities
  // ──────────────────────────────────────────────

  String _pick(List<String> options) {
    if (options.isEmpty) return '';
    return options[_random.nextInt(options.length)];
  }

  String _progressBar(int value, int max, int length) {
    final filled = (value.clamp(0, max) / max * length).round();
    final empty = length - filled;
    return '${'▓' * filled}${'░' * empty}';
  }

  String _formatCategory(Category cat) {
    switch (cat) {
      case Category.food: return 'Food & Dining';
      case Category.transport: return 'Transport';
      case Category.academic: return 'Academic';
      case Category.techTools: return 'Tech Tools';
      case Category.subscriptions: return 'Subscriptions';
      case Category.personal: return 'Personal';
      case Category.entertainment: return 'Entertainment';
      case Category.income: return 'Income';
      case Category.uncategorized: return 'Uncategorized';
    }
  }

  String _monthName(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[dt.month - 1];
  }

  String _formatDate(DateTime dt) {
    return '${dt.day} ${_monthName(dt)} ${dt.year}';
  }

  String _motivationalClose(int savingsRate, double net) {
    if (net < 0) return '⚠️ You\'re spending more than you earn this month. Let\'s fix that — ask me "how can I save more?"';
    if (savingsRate >= 30) return '🔥 Outstanding! A $savingsRate% savings rate puts you in the top tier of savers!';
    if (savingsRate >= 20) return '✅ Solid $savingsRate% savings rate! You\'re doing great.';
    if (savingsRate >= 10) return '👍 $savingsRate% savings rate — decent! Try pushing for 20% next month.';
    return '💪 Keep going! Every rupee saved is progress. Ask me for savings tips!';
  }

  String _savingsRateComment(int rate) {
    if (rate >= 30) return '🏆 That\'s an excellent savings rate! You\'re in great financial shape.';
    if (rate >= 20) return '✅ You\'re saving a healthy chunk. Well done!';
    if (rate >= 10) return '👍 Decent savings rate. Room to grow, but you\'re on the right track!';
    if (rate > 0) return '⚡ Savings rate is low. Ask me "how can I save more?" for personalized tips!';
    return '⚠️ You\'re breaking even or in deficit. Let\'s look at what we can cut.';
  }

  String _getTrendAnalysis(int expDiff, int incDiff) {
    if (incDiff > 0 && expDiff <= 0) return 'Income up, expenses down — perfect trend! 🌟';
    if (incDiff > 0 && expDiff > 0 && incDiff > expDiff) return 'Income grew faster than expenses — still a win! 💚';
    if (expDiff > 20) return 'Expenses surged significantly. Dig into what changed this month.';
    if (expDiff > 0 && incDiff < 0) return 'Spending more while earning less is a tough combo. Time to review!';
    if (expDiff < 0) return 'Nice — you spent less than last month! 👏';
    return 'Relatively stable month. Keep an eye on any new spending habits.';
  }
}

// ──────────────────────────────────────────────
// Internal data models
// ──────────────────────────────────────────────

class _ChatTurn {
  final String role;
  final String text;
  _ChatTurn({required this.role, required this.text});
}

class _FinancialContext {
  final double income;
  final double expense;
  final double lastIncome;
  final double lastExpense;
  final Map<Category, double> categoryBreakdown;
  final Map<String, double> merchantBreakdown;
  final MapEntry<Category, double>? topCategory;
  final MapEntry<String, double>? topMerchant;
  final List<Category> overBudgetCategories;
  final List<Budget> budgets;
  final List<SavingsGoal> goals;
  final AppSettings? settings;
  final DateTime now;

  _FinancialContext({
    required this.income,
    required this.expense,
    required this.lastIncome,
    required this.lastExpense,
    required this.categoryBreakdown,
    required this.merchantBreakdown,
    required this.topCategory,
    required this.topMerchant,
    required this.overBudgetCategories,
    required this.budgets,
    required this.goals,
    required this.settings,
    required this.now,
  });

  factory _FinancialContext.build({
    required List<Transaction> thisMonth,
    required List<Transaction> lastMonth,
    required List<Transaction> allTransactions,
    required List<Budget> budgets,
    required List<SavingsGoal> goals,
    required AppSettings? settings,
    required DateTime now,
  }) {
    double income = thisMonth.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
    double expense = thisMonth.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);
    double lastIncome = lastMonth.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
    double lastExpense = lastMonth.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);

    final catBreakdown = <Category, double>{};
    final merchantMap = <String, double>{};
    for (final t in thisMonth.where((t) => t.direction == TransactionDirection.debit)) {
      catBreakdown[t.category] = (catBreakdown[t.category] ?? 0) + t.amount;
      if (t.merchantName != null && t.merchantName!.isNotEmpty) {
        merchantMap[t.merchantName!] = (merchantMap[t.merchantName!] ?? 0) + t.amount;
      }
    }

    MapEntry<Category, double>? topCat;
    if (catBreakdown.isNotEmpty) {
      topCat = catBreakdown.entries.reduce((a, b) => a.value > b.value ? a : b);
    }

    MapEntry<String, double>? topMerchant;
    if (merchantMap.isNotEmpty) {
      topMerchant = merchantMap.entries.reduce((a, b) => a.value > b.value ? a : b);
    }

    final overBudget = budgets
        .where((b) => (catBreakdown[b.category] ?? 0) > b.monthlyLimit)
        .map((b) => b.category)
        .toList();

    return _FinancialContext(
      income: income,
      expense: expense,
      lastIncome: lastIncome,
      lastExpense: lastExpense,
      categoryBreakdown: catBreakdown,
      merchantBreakdown: merchantMap,
      topCategory: topCat,
      topMerchant: topMerchant,
      overBudgetCategories: overBudget,
      budgets: budgets,
      goals: goals,
      settings: settings,
      now: now,
    );
  }
}
