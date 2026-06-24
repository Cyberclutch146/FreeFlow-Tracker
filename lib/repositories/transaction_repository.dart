import 'package:isar/isar.dart';
import '../models/transaction.dart';
import '../database/database_service.dart';
import '../core/constants/app_constants.dart';

class TransactionRepository {
  final DatabaseService _db;
  TransactionRepository(this._db);

  Future<List<Transaction>> getAll() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isArchivedEqualTo(false).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByMonth(int month, int year) async {
    try {
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isArchivedEqualTo(false).and().dateBetween(start, end).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByCategory(String categoryStr) async {
    try {
      final category = Category.values.firstWhere((e) => e.name == categoryStr);
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isArchivedEqualTo(false).and().categoryEqualTo(category).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByProject(String projectId) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isArchivedEqualTo(false).and().projectIdEqualTo(projectId).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getByStudent(String studentId) async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isArchivedEqualTo(false).and().studentIdEqualTo(studentId).sortByDateDesc().findAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getUnconfirmed() async {
    try {
      final isar = await DatabaseService.instance;
      return await isar.transactions.filter().isArchivedEqualTo(false).and().isConfirmedEqualTo(false).sortByDateDesc().findAll();
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

  Future<void> archive(String id) async {
    try {
      final isar = await DatabaseService.instance;
      final t = await getById(id);
      if (t != null) {
        await isar.writeTxn(() async {
          await isar.transactions.put(t.copyWith(isArchived: true));
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> splitTransaction(String parentId, List<Transaction> children) async {
    try {
      final isar = await DatabaseService.instance;
      final parent = await getById(parentId);
      if (parent != null) {
        await isar.writeTxn(() async {
          await isar.transactions.delete(parent.isarId);
          await isar.transactions.putAll(children);
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
      return txns.where((t) => t.direction == direction).fold<double>(0.0, (sum, item) => sum + item.amount);
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
      yield* isar.transactions.filter().isArchivedEqualTo(false).sortByDateDesc().watch(fireImmediately: true);
    } catch (e) {
      rethrow;
    }
  }
}