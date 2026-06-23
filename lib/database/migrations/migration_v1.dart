import 'package:isar/isar.dart';
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