import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotifService() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('todo_notif_logo');
    var initializationSettingIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: initializationSettingIos);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  notifDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotif(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(id, title, body, await notifDetails());
  }

  Future scheduleNotif(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledNotifDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledNotifDateTime, tz.local),
        await notifDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future cancelNotif({required int id}) async {
    notificationsPlugin.cancel(id);
  }
}
