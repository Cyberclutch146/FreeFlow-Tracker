import 'package:isar/isar.dart';
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