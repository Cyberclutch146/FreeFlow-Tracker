import 'package:isar/isar.dart';
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

  Future<List<Budget>> getAll() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.budgets.where().findAll();
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

  Stream<List<Budget>> watchAll() async* {
    try {
      final isar = await DatabaseService.instance;
      yield* isar.budgets.where().watch(fireImmediately: true);
    } catch (e) {
      rethrow;
    }
  }
}