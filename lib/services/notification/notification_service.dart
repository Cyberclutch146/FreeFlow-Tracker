import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInitSettings);
    
    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'freelanceflow_channel',
      'FreelanceFlow Notifications',
      channelDescription: 'Alerts and summaries from your financial assistant',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id: id, title: title, body: body, notificationDetails: platformDetails);
  }

  static Future<void> scheduleWeeklyDigest(DateTime scheduledTime) async {
    const androidDetails = AndroidNotificationDetails(
      'weekly_digest',
      'Weekly Financial Digest',
      channelDescription: 'Your weekly spending and income summary',
      importance: Importance.high,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id: 1001,
      title: 'Weekly Digest Ready',
      body: 'Tap to review your spending from last week.',
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
}
