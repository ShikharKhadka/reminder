import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reminder/app/locator/locator.dart';

import 'app/data/app_path_provider.dart';
import 'app/routes/app_pages.dart';
import 'notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await AppPathProvider.initPath();

  NotificationService().initNotification();

  initLocator();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
