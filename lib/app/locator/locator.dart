import 'package:get_it/get_it.dart';
import 'package:reminder/app/data/google_calendar_api.dart';
import 'package:reminder/app/modules/database/notification_db.dart';

import '../base_client.dart/base_client.dart';

GetIt locator = GetIt.instance;
void initLocator() {
  locator.registerLazySingleton(
    () => BaseClient(),
  );
  locator.registerLazySingleton<NotificationDatabase>(
      () => NotificationDatabase.notificationDatabase);
  locator.registerLazySingleton(() => GoogleCalendarApi(baseClient: locator()));
}
