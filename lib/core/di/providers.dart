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

final settingsProvider = FutureProvider((ref) =>
  ref.read(settingsRepositoryProvider).get());

final recentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
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
    ],
  );
});