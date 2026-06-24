import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await NotificationService.initialize();
      
      switch (task) {
        case 'weekly_digest_task':
          // We could fetch transactions here and generate a summary,
          // but for now we just show a generic reminder to open the app.
          await NotificationService.showNotification(
            id: 2001,
            title: 'Weekly Financial Digest',
            body: 'Your weekly spending and income summary is ready. Tap to view.',
          );
          break;
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

class BackgroundWorker {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );
  }

  static void scheduleWeeklyDigest() {
    Workmanager().registerPeriodicTask(
      'weekly_digest_task',
      'weekly_digest_task',
      frequency: const Duration(days: 7),
    );
  }

  static void cancelAll() {
    Workmanager().cancelAll();
  }
}
