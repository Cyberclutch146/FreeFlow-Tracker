import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart';
import '../models/weekly_report.dart';
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
import 'dart:convert';

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
        WeeklyReportSchema,
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
  IsarCollection<WeeklyReport> get weeklyReports => _isar.weeklyReports;
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
      // Re-initialize default settings to prevent 'Bad state: No element'
      await _isar.appSettings.put(AppSettings(
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

  Future<String> exportAllJson() async {
    final Map<String, dynamic> data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'transactions': (await _isar.transactions.where().findAll()).map((e) => e.toJson()).toList(),
      'projects': (await _isar.projects.where().findAll()).map((e) => e.toJson()).toList(),
      'students': (await _isar.students.where().findAll()).map((e) => e.toJson()).toList(),
      'savingsGoals': (await _isar.savingsGoals.where().findAll()).map((e) => e.toJson()).toList(),
      'budgets': (await _isar.budgets.where().findAll()).map((e) => e.toJson()).toList(),
      'settings': (await _isar.appSettings.where().findFirst())?.toJson() ?? {},
    };
    return jsonEncode(data);
  }

  Future<void> importFromJson(String jsonStr) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      await _isar.writeTxn(() async {
        if (data.containsKey('transactions')) {
          final txns = (data['transactions'] as List).map((e) => Transaction.fromJson(e)).toList();
          await _isar.transactions.putAll(txns);
        }
        if (data.containsKey('projects')) {
          final projs = (data['projects'] as List).map((e) => Project.fromJson(e)).toList();
          await _isar.projects.putAll(projs);
        }
        if (data.containsKey('students')) {
          final studs = (data['students'] as List).map((e) => Student.fromJson(e)).toList();
          await _isar.students.putAll(studs);
        }
        if (data.containsKey('savingsGoals')) {
          final goals = (data['savingsGoals'] as List).map((e) => SavingsGoal.fromJson(e)).toList();
          await _isar.savingsGoals.putAll(goals);
        }
        if (data.containsKey('budgets')) {
          final bgs = (data['budgets'] as List).map((e) => Budget.fromJson(e)).toList();
          await _isar.budgets.putAll(bgs);
        }
        if (data.containsKey('settings') && (data['settings'] as Map).isNotEmpty) {
          final set = AppSettings.fromJson(data['settings']);
          await _isar.appSettings.put(set);
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}