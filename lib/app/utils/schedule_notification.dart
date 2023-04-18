import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleMultipleNotification {
  scheduleNotification(
      {required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      int? randomNumber,
      String? payload,
      int? id,
      String? title,
      String? body,
      DateTimeComponents? dateTimeComponents,
      tz.TZDateTime? sxheduleNotification,
      DateTime? dateTime}) async {
    final Int64List vibrationPattern = Int64List(20);
    List.generate(20, (index) => vibrationPattern[index] = 750);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id!,
      title,
      body,
      matchDateTimeComponents: dateTimeComponents,
      sxheduleNotification!, //schedule the notification to show after 2 seconds.
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder',
          'reminder',
          sound: const RawResourceAndroidNotificationSound('notification'),
          importance: Importance.max,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.alarm,
          priority: Priority.max,
          autoCancel: false,
          enableVibration: true,
          vibrationPattern: vibrationPattern,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              id.toString(),
              'Remind after 1 hour',
              showsUserInterface: true,
            )
          ],
        ),
      ),
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }
}
