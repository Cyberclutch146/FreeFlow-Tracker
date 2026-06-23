import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../database/database_service.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/project_repository.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../repositories/budget_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../services/sms_service.dart';
import '../../services/insights_engine.dart';
import '../../services/savings_advisor.dart';
import '../../widgets/navigation/main_scaffold.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/transactions/transactions_screen.dart';
import '../../screens/income/income_screen.dart';
import '../../screens/goals/goals_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../models/transaction.dart';
import '../../models/app_settings.dart';
import '../../models/project.dart';
import '../../models/student.dart';
import '../../models/savings_goal.dart';
import '../../models/budget.dart';
import '../../core/constants/app_constants.dart';
import '../theme/theme_config.dart';
import '../../services/ai/gemini_service.dart';
import '../../screens/ai/ai_chat_screen.dart';
import '../../screens/ai/ai_report_screen.dart';
import '../../models/insight_card.dart';
import '../../models/advisor_card.dart';

final databaseServiceProvider = Provider((ref) => DatabaseService());

final transactionRepositoryProvider = Provider((ref) =>
  TransactionRepository(ref.read(databaseServiceProvider)));

final goalRepositoryProvider = Provider((ref) =>
  GoalRepository(ref.read(databaseServiceProvider)));

final budgetRepositoryProvider = Provider((ref) =>
  BudgetRepository(ref.read(databaseServiceProvider)));

final settingsRepositoryProvider = Provider((ref) =>
  SettingsRepository(ref.read(databaseServiceProvider)));

final projectRepositoryProvider = Provider((ref) =>
  ProjectRepository(ref.read(databaseServiceProvider)));

final studentRepositoryProvider = Provider((ref) =>
  StudentRepository(ref.read(databaseServiceProvider)));

final smsServiceProvider = Provider((ref) => SmsService());

final insightsEngineProvider = Provider((ref) => InsightsEngine());

final savingsAdvisorProvider = Provider((ref) => SavingsAdvisor());

final geminiServiceProvider = Provider((ref) {
  final gemini = GeminiService();
  // API key will be configured from settings
  final settingsAsync = ref.watch(settingsProvider);
  final apiKey = settingsAsync.valueOrNull?.geminiApiKey;
  if (apiKey != null && apiKey.isNotEmpty) {
    gemini.configure(apiKey);
  }
  return gemini;
});

final settingsProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watch();
});

final themeConfigProvider = Provider<ThemeConfig>((ref) {
  final settingsAsync = ref.watch(settingsProvider);
  final themeMode = settingsAsync.valueOrNull?.theme ?? AppThemeMode.dark;
  
  switch (themeMode) {
    case AppThemeMode.dark:
      return ThemeConfig.midnightAmethyst;
    case AppThemeMode.oled:
      return ThemeConfig.pureOled;
    case AppThemeMode.light:
      return ThemeConfig.midnightAmethyst; // Fallback, light mode is currently replaced by Matte themes
  }
});

final recentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

final unconfirmedTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  // We use FutureProvider here as a simple way to query them on load
  return ref.watch(transactionRepositoryProvider).getUnconfirmed();
});

final insightsProvider = FutureProvider<List<InsightCard>>((ref) async {
  final txns = await ref.watch(transactionRepositoryProvider).getAll();
  final budgets = await ref.watch(budgetRepositoryProvider).getAll();
  final projects = await ref.watch(projectRepositoryProvider).getAll();
  final settings = await ref.watch(settingsRepositoryProvider).get();
  
  final now = DateTime.now();
  final currentMonth = txns.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
  final lastMonth = txns.where((t) {
    var prevMonth = now.month - 1 == 0 ? 12 : now.month - 1;
    var prevYear = now.month - 1 == 0 ? now.year - 1 : now.year;
    return t.date.year == prevYear && t.date.month == prevMonth;
  }).toList();
  final last3Months = txns.where((t) => now.difference(t.date).inDays <= 90).toList();

  return ref.watch(insightsEngineProvider).generate(
    currentMonthTxns: currentMonth,
    lastMonthTxns: lastMonth,
    last3MonthsTxns: last3Months,
    budgets: budgets,
    projects: projects,
    settings: settings,
  );
});

final advisorProvider = FutureProvider<List<AdvisorCard>>((ref) async {
  final txns = await ref.watch(transactionRepositoryProvider).getAll();
  final goals = await ref.watch(goalRepositoryProvider).getAll();
  final settings = await ref.watch(settingsRepositoryProvider).get();
  
  final now = DateTime.now();
  final currentMonth = txns.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
  final last3Months = txns.where((t) => now.difference(t.date).inDays <= 90).toList();

  return ref.watch(savingsAdvisorProvider).generate(
    goals: goals,
    currentMonthTxns: currentMonth,
    last3MonthsTxns: last3Months,
    settings: settings,
  );
});

final projectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).watchAll();
});

final studentsProvider = StreamProvider<List<Student>>((ref) {
  return ref.watch(studentRepositoryProvider).watchAll();
});

final goalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  return ref.watch(goalRepositoryProvider).watchAll();
});

final budgetsProvider = StreamProvider<List<Budget>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchAll();
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/income', builder: (context, state) => const IncomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/goals', builder: (context, state) => const GoalsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/reports', builder: (context, state) => const ReportsScreen())]),
        ],
      ),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/ai-chat', builder: (context, state) => const AiChatScreen()),
      GoRoute(path: '/ai-report', builder: (context, state) => const AiReportScreen()),
    ],
  );
});