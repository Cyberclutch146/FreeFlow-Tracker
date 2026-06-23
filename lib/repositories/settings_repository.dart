import 'package:isar/isar.dart';
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