import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_planner/exceptions/app_exceptions.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotifService() async {
    if (Platform.isAndroid) {
      notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('ic_notif_dark');
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
        android: AndroidNotificationDetails('channelId', 'TaskPlanner',
            importance: Importance.max, priority: Priority.high),
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
    if (scheduledNotifDateTime.isAfter(DateTime.now())) {
      return notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledNotifDateTime, tz.local),
          await notifDetails(),
          androidAllowWhileIdle: true,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } else {
      throw ImpossibleReminderTimeException();
    }
  }

  Future cancelNotif({required int id}) async {
    notificationsPlugin.cancel(id);
  }
}
