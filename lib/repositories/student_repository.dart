import 'package:isar/isar.dart';
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

  Stream<List<Student>> watchAll() async* {
    try {
      final isar = await DatabaseService.instance;
      yield* isar.students.where().sortByCreatedAtDesc().watch(fireImmediately: true);
    } catch (e) {
      rethrow;
    }
  }
}