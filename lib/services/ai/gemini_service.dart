import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/transaction.dart';
import '../../models/savings_goal.dart';
import '../../models/budget.dart';
import '../../models/app_settings.dart';
import '../../core/constants/app_constants.dart';

class GeminiService {
  GenerativeModel? _flashModel;
  GenerativeModel? _flashLiteModel;
  ChatSession? _chatSession;
  String? _apiKey;

  // Rate limiter
  final List<DateTime> _recentCalls = [];
  static const int _maxCallsPerMinute = 14; // Stay under 15 RPM limit

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  void configure(String apiKey) {
    _apiKey = apiKey;
    _flashModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 2048,
      ),
    );
    _flashLiteModel = GenerativeModel(
      model: 'gemini-2.0-flash-lite',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        maxOutputTokens: 512,
      ),
    );
    _chatSession = null; // Reset chat session
  }

  // ──────────────────────────────────────────────
  // Rate Limiter
  // ──────────────────────────────────────────────

  bool _checkRateLimit() {
    final now = DateTime.now();
    _recentCalls.removeWhere((t) => now.difference(t).inSeconds > 60);
    if (_recentCalls.length >= _maxCallsPerMinute) {
      return false; // Rate limited
    }
    _recentCalls.add(now);
    return true;
  }

  // ──────────────────────────────────────────────
  // 1. Financial Chat Assistant
  // ──────────────────────────────────────────────

  Future<String> chat(String userMessage, {
    required List<Transaction> recentTransactions,
    required List<SavingsGoal> goals,
    required List<Budget> budgets,
    required AppSettings settings,
  }) async {
    if (!isConfigured) return 'Please configure your Gemini API key in Settings.';
    if (!_checkRateLimit()) return 'Rate limited. Please wait a moment before asking again.';

    try {
      // Initialize chat session with financial context on first message
      if (_chatSession == null) {
        final context = _buildFinancialContext(recentTransactions, goals, budgets, settings);
        _chatSession = _flashModel!.startChat(history: [
          Content.text('''You are a smart, friendly financial assistant for a freelancer.
You analyze their real financial data and give concise, actionable advice.
Be warm but professional. Use ₹ for currency. Keep responses under 200 words.
Never make up data — only reference what's provided below.

Here is the user's current financial snapshot:
$context'''),
          Content.model([TextPart('Got it! I have your financial data loaded. Ask me anything about your spending, savings, or income — I\'m here to help! 💰')]),
        ]);
      }

      final response = await _chatSession!.sendMessage(Content.text(userMessage));
      return response.text ?? 'I couldn\'t generate a response. Please try again.';
    } catch (e) {
      return 'Error: ${e.toString().length > 100 ? e.toString().substring(0, 100) : e}';
    }
  }

  void resetChat() {
    _chatSession = null;
  }

  // ──────────────────────────────────────────────
  // 2. Monthly Financial Report
  // ──────────────────────────────────────────────

  Future<String> generateMonthlyReport({
    required List<Transaction> currentMonthTxns,
    required List<Transaction> lastMonthTxns,
    required List<SavingsGoal> goals,
    required List<Budget> budgets,
    required AppSettings settings,
  }) async {
    if (!isConfigured) return 'Configure your Gemini API key to unlock AI reports.';
    if (!_checkRateLimit()) return 'Rate limited. Try again in a minute.';

    try {
      double income = currentMonthTxns.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
      double expense = currentMonthTxns.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);
      double lastIncome = lastMonthTxns.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
      double lastExpense = lastMonthTxns.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);

      // Category breakdown
      Map<String, double> categorySpend = {};
      for (var t in currentMonthTxns.where((t) => t.direction == TransactionDirection.debit)) {
        categorySpend[t.category.name] = (categorySpend[t.category.name] ?? 0) + t.amount;
      }

      // Top merchants
      Map<String, double> merchantSpend = {};
      for (var t in currentMonthTxns.where((t) => t.direction == TransactionDirection.debit && t.merchantName != null)) {
        merchantSpend[t.merchantName!] = (merchantSpend[t.merchantName!] ?? 0) + t.amount;
      }

      final prompt = '''Generate a concise monthly financial report for a freelancer. Use emojis, bold headers, and bullet points. Keep it under 300 words. Be specific with numbers.

DATA:
- This month: Income ₹${income.toStringAsFixed(0)}, Expenses ₹${expense.toStringAsFixed(0)}, Savings ₹${(income - expense).toStringAsFixed(0)}
- Last month: Income ₹${lastIncome.toStringAsFixed(0)}, Expenses ₹${lastExpense.toStringAsFixed(0)}
- Income target: ₹${settings.monthlyIncomeTarget.toStringAsFixed(0)}
- Category breakdown: ${categorySpend.entries.map((e) => '${e.key}: ₹${e.value.toStringAsFixed(0)}').join(', ')}
- Top merchants: ${merchantSpend.entries.take(5).map((e) => '${e.key}: ₹${e.value.toStringAsFixed(0)}').join(', ')}
- Active savings goals: ${goals.where((g) => g.status == GoalStatus.active).map((g) => '${g.name} (${(g.currentAmount / g.targetAmount * 100).toStringAsFixed(0)}%)').join(', ')}
- Budget status: ${budgets.map((b) {
        double spent = currentMonthTxns.where((t) => t.direction == TransactionDirection.debit && t.category == b.category).fold(0, (s, t) => s + t.amount);
        return '${b.category.name}: ₹${spent.toStringAsFixed(0)}/₹${b.monthlyLimit.toStringAsFixed(0)}';
      }).join(', ')}

Include: Summary, Key Highlights, Concerns, Actionable Tips.''';

      final response = await _flashModel!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not generate report.';
    } catch (e) {
      return 'Error generating report: $e';
    }
  }

  // ──────────────────────────────────────────────
  // 3. Smart Categorization
  // ──────────────────────────────────────────────

  Future<Map<String, String>> batchCategorize(List<String> merchantNames) async {
    if (!isConfigured || merchantNames.isEmpty) return {};
    if (!_checkRateLimit()) return {};

    final validCategories = Category.values.map((c) => c.name).join(', ');

    try {
      final prompt = '''Categorize each merchant into exactly one category from this list:
$validCategories

Merchants:
${merchantNames.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

Respond ONLY with a numbered list in format: "1. category_name"
No explanations.''';

      final response = await _flashLiteModel!.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      Map<String, String> results = {};
      final lines = text.split('\n');
      for (int i = 0; i < lines.length && i < merchantNames.length; i++) {
        final match = RegExp(r'\d+\.\s*(\w+)').firstMatch(lines[i]);
        if (match != null) {
          final cat = match.group(1)!;
          if (Category.values.any((c) => c.name == cat)) {
            results[merchantNames[i]] = cat;
          }
        }
      }
      return results;
    } catch (e) {
      return {};
    }
  }

  // ──────────────────────────────────────────────
  // 4. Quick Financial Insight (one-shot)
  // ──────────────────────────────────────────────

  Future<String> getQuickInsight({
    required List<Transaction> transactions,
    required String question,
  }) async {
    if (!isConfigured) return 'Configure API key first.';
    if (!_checkRateLimit()) return 'Rate limited.';

    try {
      double income = transactions.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
      double expense = transactions.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);

      final prompt = '''You are a financial advisor. Answer in 1-2 sentences.
Income this month: ₹${income.toStringAsFixed(0)}
Expenses this month: ₹${expense.toStringAsFixed(0)}
Transaction count: ${transactions.length}
Question: $question''';

      final response = await _flashLiteModel!.generateContent([Content.text(prompt)]);
      return response.text ?? 'No insight available.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  String _buildFinancialContext(List<Transaction> txns, List<SavingsGoal> goals, List<Budget> budgets, AppSettings settings) {
    final now = DateTime.now();
    final thisMonth = txns.where((t) => t.date.year == now.year && t.date.month == now.month).toList();

    double income = thisMonth.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
    double expense = thisMonth.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);

    Map<String, double> catSpend = {};
    for (var t in thisMonth.where((t) => t.direction == TransactionDirection.debit)) {
      catSpend[t.category.name] = (catSpend[t.category.name] ?? 0) + t.amount;
    }

    return '''
Monthly Income Target: ₹${settings.monthlyIncomeTarget.toStringAsFixed(0)}
This Month: Income ₹${income.toStringAsFixed(0)}, Expenses ₹${expense.toStringAsFixed(0)}, Net ₹${(income - expense).toStringAsFixed(0)}
Total Transactions: ${thisMonth.length}
Category Breakdown: ${catSpend.entries.map((e) => '${e.key}: ₹${e.value.toStringAsFixed(0)}').join(', ')}
Active Goals: ${goals.where((g) => g.status == GoalStatus.active).map((g) => '${g.name} (₹${g.currentAmount.toStringAsFixed(0)}/₹${g.targetAmount.toStringAsFixed(0)})').join(', ')}
Budgets: ${budgets.map((b) {
      double spent = thisMonth.where((t) => t.direction == TransactionDirection.debit && t.category == b.category).fold(0, (s, t) => s + t.amount);
      return '${b.category.name}: ₹${spent.toStringAsFixed(0)}/₹${b.monthlyLimit.toStringAsFixed(0)}';
    }).join(', ')}
Recent transactions (last 10): ${txns.take(10).map((t) => '${t.date.day}/${t.date.month} ${t.direction.name} ₹${t.amount.toStringAsFixed(0)} ${t.category.name} ${t.merchantName ?? t.note ?? ""}').join(' | ')}
''';
  }
}
