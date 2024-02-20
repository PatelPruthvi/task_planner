import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_planner/exceptions/app_exceptions.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
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
        const AndroidInitializationSettings('ic_notif_cream');
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
            color: AppColors.kblue600,
            colorized: true,
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
    if (scheduledNotifDateTime.isAfter(DateTime.now())) {
      return notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledNotifDateTime, tz.local),
          await notifDetails(),
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
