import 'package:isar/isar.dart';
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