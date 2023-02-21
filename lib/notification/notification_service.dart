import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotification(int id, String title, String body,
      DateTime dateTime, DateTimeComponents dateTimeComponents) async {
    log(dateTime.year.toString());
    log(dateTime.month.toString());
    log(dateTime.day.toString());
    log(dateTime.hour.toString());
    log(dateTime.minute.toString());
    log(tz.local.toString());
    log(id.toString()); // Here you can get your current local time
    String dateNow = DateTime.now().toString();
    final Int64List vibrationPattern = Int64List(20);
    List.generate(20, (index) => vibrationPattern[index] = 750);

    print(vibrationPattern);
    // vibrationPattern[1] = 10000;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      matchDateTimeComponents: dateTimeComponents,
      payload: 'title',

      tz.TZDateTime.now(tz.local).add(dateTime.difference(
          DateTime.now())), //schedule the notification to show after 2 seconds.
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
              id.toString(), 'Remind after 1 hour',
              showsUserInterface: true,
              // inputs: [const AndroidNotificationActionInput()],
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

  onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.id != null) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationResponse.id!,
          notificationResponse.payload,
          'body',
          tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'id',
              'dsadas',
              sound: RawResourceAndroidNotificationSound('notification'),
              importance: Importance.max,
              visibility: NotificationVisibility.public,
              category: AndroidNotificationCategory.alarm,
              priority: Priority.max,
              autoCancel: false,
              // actions: <AndroidNotificationAction>[
              //   AndroidNotificationAction(
              //     id.toString(), 'Remind after 1 hour',
              //     showsUserInterface: true,
              //     // inputs: [const AndroidNotificationActionInput()],
              //   )
              // ],
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }
  }
}
