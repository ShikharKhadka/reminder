import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/app/utils/schedule_notification.dart';
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
    // print(id);
    // Here you can get your current local time
    ScheduleMultipleNotification().scheduleNotification(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        id: id,
        body: body,
        title: title,
        dateTimeComponents: dateTimeComponents,
        payload: title,
        sxheduleNotification: tz.TZDateTime.now(tz.local).add(
          dateTime.difference(DateTime.now()),
        ),
        dateTime: dateTime);
    // vibrationPattern[1] = 10000;
  }

  onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print(notificationResponse.id.toString());
    if (notificationResponse.id != null) {
      Random random = Random();
      int randomNumber = random.nextInt(10000);
      ScheduleMultipleNotification().scheduleNotification(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        id: randomNumber,
        body: 'this is reminder',
        title: notificationResponse.payload,
        sxheduleNotification:
            tz.TZDateTime.now(tz.local).add(const Duration(hours: 1)),
      );
    }
  }
}
