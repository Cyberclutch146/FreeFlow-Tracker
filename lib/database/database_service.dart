import 'package:isar/isar.dart';
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