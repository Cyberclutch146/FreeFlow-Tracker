import os

files = {
"lib/database/database_service.dart": """import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart';
import '../models/sms_raw_log.dart';
import '../models/project.dart';
import '../models/student.dart';
import '../models/session.dart';
import '../models/savings_goal.dart';
import '../models/goal_contribution.dart';
import '../models/budget.dart';
import '../models/insight_card.dart';
import '../models/advisor_card.dart';
import '../models/app_settings.dart';
import '../core/constants/app_constants.dart';
import 'migrations/migration_v1.dart';

class DatabaseService {
  static late Isar _isar;

  static Future<Isar> get instance async {
    if (Isar.instanceNames.isEmpty) {
      await initialize();
    }
    return _isar;
  }

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        TransactionSchema,
        SmsRawLogSchema,
        ProjectSchema,
        StudentSchema,
        SessionSchema,
        SavingsGoalSchema,
        GoalContributionSchema,
        BudgetSchema,
        InsightCardSchema,
        AdvisorCardSchema,
        AppSettingsSchema,
      ],
      directory: dir.path,
      name: AppConstants.kDbName,
    );
    await MigrationV1.run(_isar);
  }

  IsarCollection<Transaction> get transactions => _isar.transactions;
  IsarCollection<SmsRawLog> get smsRawLogs => _isar.smsRawLogs;
  IsarCollection<Project> get projects => _isar.projects;
  IsarCollection<Student> get students => _isar.students;
  IsarCollection<Session> get sessions => _isar.sessions;
  IsarCollection<SavingsGoal> get goals => _isar.savingsGoals;
  IsarCollection<GoalContribution> get contributions => _isar.goalContributions;
  IsarCollection<Budget> get budgets => _isar.budgets;
  IsarCollection<InsightCard> get insightCards => _isar.insightCards;
  IsarCollection<AdvisorCard> get advisorCards => _isar.advisorCards;
  IsarCollection<AppSettings> get settings => _isar.appSettings;

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }

  Future<String> exportAllJson() async {
    return '{}'; // STUB
  }

  Future<void> importFromJson(String json) async {
    // STUB
  }
}
""",

"lib/database/migrations/migration_v1.dart": """import 'package:isar/isar.dart';
import '../../models/app_settings.dart';
import '../../core/constants/app_constants.dart';

class MigrationV1 {
  static Future<void> run(Isar isar) async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      await isar.writeTxn(() async {
        await isar.appSettings.put(AppSettings(
          id: AppConstants.kSettingsSingletonId,
          monthlyIncomeTarget: 0.0,
          budgetResetDay: 1,
          theme: AppThemeMode.dark,
          smsPermissionGranted: false,
          onboardingComplete: false,
          incomeSources: [],
        ));
      });
    }
  }
}
""",

"lib/repositories/transaction_repository.dart": """import 'package:isar/isar.dart';
import '../models/transaction.dart';
import '../database/database_service.dart';
import '../core/constants/app_constants.dart';

class TransactionRepository {
  final DatabaseService _db;
  TransactionRepository(this._db);

  Future<List<Transaction>> getAll() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.where().sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByMonth(int month, int year) async {
    try {
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().dateBetween(start, end).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByCategory(String categoryStr) async {
    try {
      final category = Category.values.firstWhere((e) => e.name == categoryStr);
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().categoryEqualTo(category).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByProject(String projectId) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().projectIdEqualTo(projectId).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByStudent(String studentId) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().studentIdEqualTo(studentId).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getUnconfirmed() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isConfirmedEqualTo(false).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction?> getById(String id) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().idEqualTo(id).findFirst();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(Transaction transaction) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.transactions.put(transaction);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveAll(List<Transaction> transactions) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.transactions.putAll(transactions);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final isar = await DatabaseService.instance;
      final t = await getById(id);
      if (t != null) {
        await isar.writeTxn(() async {
          await isar.transactions.delete(t.isarId);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getTotalByDirection(String directionStr, int month, int year) async {
    try {
      final direction = TransactionDirection.values.firstWhere((e) => e.name == directionStr);
      final txns = await getByMonth(month, year);
      return txns.where((t) => t.direction == direction).fold(0.0, (sum, item) => sum + item.amount);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, double>> getCategoryTotals(int month, int year) async {
    try {
      final txns = await getByMonth(month, year);
      final Map<String, double> totals = {};
      for (final t in txns) {
        totals[t.category.name] = (totals[t.category.name] ?? 0.0) + t.amount;
      }
      return totals;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Transaction>> watchAll() async* {
    try {
      final isar = await DatabaseService.instance;
      yield* isar.transactions.where().sortByDateDesc().watch(fireImmediately: true);
    } catch (e) {
      rethrow;
    }
  }
}
""",

"lib/repositories/project_repository.dart": """import 'package:isar/isar.dart';
import '../models/project.dart';
import '../database/database_service.dart';
import '../core/constants/app_constants.dart';

class ProjectRepository {
  final DatabaseService _db;
  ProjectRepository(this._db);

  Future<List<Project>> getAll() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.projects.where().sortByCreatedAtDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<Project?> getById(String id) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.projects.filter().idEqualTo(id).findFirst();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Project>> getByStatus(String statusStr) async {
    try {
      final status = ProjectStatus.values.firstWhere((e) => e.name == statusStr);
      final isar = await DatabaseService.instance;
      return await isar.projects.filter().statusEqualTo(status).sortByCreatedAtDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(Project project) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.projects.put(project);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final isar = await DatabaseService.instance;
      final p = await getById(id);
      if (p != null) {
        await isar.writeTxn(() async {
          await isar.projects.delete(p.isarId);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Project>> watchAll() async* {
    try {
      final isar = await DatabaseService.instance;
      yield* isar.projects.where().sortByCreatedAtDesc().watch(fireImmediately: true);
    } catch (e) {
      rethrow;
    }
  }
}
""",

"lib/repositories/student_repository.dart": """import 'package:isar/isar.dart';
import '../models/student.dart';
import '../models/session.dart';
import '../database/database_service.dart';

class StudentRepository {
  final DatabaseService _db;
  StudentRepository(this._db);

  Future<List<Student>> getAll() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.students.where().sortByCreatedAtDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Student>> getActive() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.students.filter().isActiveEqualTo(true).sortByCreatedAtDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<Student?> getById(String id) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.students.filter().idEqualTo(id).findFirst();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(Student student) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.students.put(student);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final isar = await DatabaseService.instance;
      final s = await getById(id);
      if (s != null) {
        await isar.writeTxn(() async {
          await isar.students.delete(s.isarId);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Session>> getSessionsForStudent(String studentId) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.sessions.filter().studentIdEqualTo(studentId).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSession(Session session) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.sessions.put(session);
      });
    } catch (e) {
      rethrow;
    }
  }
}
""",

"lib/repositories/goal_repository.dart": """import 'package:isar/isar.dart';
import '../models/savings_goal.dart';
import '../models/goal_contribution.dart';
import '../database/database_service.dart';
import '../core/constants/app_constants.dart';

class GoalRepository {
  final DatabaseService _db;
  GoalRepository(this._db);

  Future<List<SavingsGoal>> getAll() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.savingsGoals.where().sortByCreatedAtDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SavingsGoal>> getActive() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.savingsGoals.filter().statusEqualTo(GoalStatus.active).sortByCreatedAtDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<SavingsGoal?> getById(String id) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.savingsGoals.filter().idEqualTo(id).findFirst();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(SavingsGoal goal) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.savingsGoals.put(goal);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final isar = await DatabaseService.instance;
      final g = await getById(id);
      if (g != null) {
        await isar.writeTxn(() async {
          await isar.savingsGoals.delete(g.isarId);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addContribution(GoalContribution contribution) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.goalContributions.put(contribution);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GoalContribution>> getContributions(String goalId) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.goalContributions.filter().goalIdEqualTo(goalId).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SavingsGoal>> watchAll() async* {
    try {
      final isar = await DatabaseService.instance;
      yield* isar.savingsGoals.where().sortByCreatedAtDesc().watch(fireImmediately: true);
    } catch (e) {
      rethrow;
    }
  }
}
""",

"lib/repositories/budget_repository.dart": """import 'package:isar/isar.dart';
import '../models/budget.dart';
import '../database/database_service.dart';
import '../core/constants/app_constants.dart';

class BudgetRepository {
  final DatabaseService _db;
  BudgetRepository(this._db);

  Future<List<Budget>> getForMonth(int month, int year) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.budgets.filter().yearEqualTo(year).and().monthEqualTo(month).findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<Budget?> getForCategory(String categoryStr, int month, int year) async {
    try {
      final category = Category.values.firstWhere((e) => e.name == categoryStr);
      final isar = await DatabaseService.instance;
      return await isar.budgets.filter()
          .categoryEqualTo(category)
          .and()
          .yearEqualTo(year)
          .and()
          .monthEqualTo(month)
          .findFirst();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(Budget budget) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.budgets.put(budget);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveAll(List<Budget> budgets) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.budgets.putAll(budgets);
      });
    } catch (e) {
      rethrow;
    }
  }
}
""",

"lib/repositories/settings_repository.dart": """import 'package:isar/isar.dart';
import '../models/app_settings.dart';
import '../database/database_service.dart';

class SettingsRepository {
  final DatabaseService _db;
  SettingsRepository(this._db);

  Future<AppSettings> get() async {
    try {
      final isar = await DatabaseService.instance;
      final settings = await isar.appSettings.where().findFirst();
      if (settings != null) return settings;
      throw Exception('Settings not initialized');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(AppSettings settings) async {
    try {
      final isar = await DatabaseService.instance;
      await isar.writeTxn(() async {
        await isar.appSettings.put(settings);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(AppSettings Function(AppSettings) updater) async {
    try {
      final current = await get();
      final updated = updater(current);
      await save(updated);
    } catch (e) {
      rethrow;
    }
  }
}
""",

"lib/services/sms_service.dart": """import '../models/sms_raw_log.dart';

class SmsService {
  Future<bool> requestPermission() async {
    return false;
  }

  Future<List<SmsRawLog>> fetchInboxHistory() async {
    return [];
  }

  Stream<SmsRawLog> watchIncomingSms() async* {
    // PHASE 3: implement full SMS parsing here
    yield* const Stream.empty();
  }
}
""",

"lib/services/insights_engine.dart": """import '../models/insight_card.dart';
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
""",

"lib/services/savings_advisor.dart": """import '../models/advisor_card.dart';
import '../models/savings_goal.dart';
import '../models/transaction.dart';
import '../models/app_settings.dart';

class SavingsAdvisor {
  Future<List<AdvisorCard>> generate({
    required List<SavingsGoal> goals,
    required List<Transaction> transactions,
    required AppSettings settings,
  }) async {
    // PHASE 8: implement all 6 capabilities here
    return [];
  }
}
""",

"lib/core/di/providers.dart": """import 'package:flutter_riverpod/flutter_riverpod.dart';
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
"""
}

for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.strip())
