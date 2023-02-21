
import 'package:get_it/get_it.dart';
import 'package:reminder/app/modules/database/notification_db.dart';

GetIt locator = GetIt.instance;
void initLocator() {
  locator.registerLazySingleton<NotificationDatabase>(
      () => NotificationDatabase.notificationDatabase);
}
