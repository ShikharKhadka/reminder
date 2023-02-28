import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:reminder/app/modules/database/deleted_notification_db.dart';
import 'package:reminder/app/modules/model/notification_db_model.dart';

class DeleteController extends GetxController {
  List<NotificationDdModel> deletedNotificatioNList = [];
  TextEditingController searchEditingController = TextEditingController();
  List<NotificationDdModel> search = [];
  List<NotificationDdModel> searchFilter = [];

  @override
  void onInit() async {
    super.onInit();
    await getDeletedDBList();
    searchTap();
  }

  Future<void> getDeletedDBList() async {
    List<NotificationDdModel> dbResult = await DeletedNotificationDatabase
        .deletednotificationDatabase
        .queryDeletedNotification();
    if (dbResult.isNotEmpty) {
      deletedNotificatioNList.addAll(dbResult);
      update();
    }
  }

  searchTap() {
    if (searchEditingController.text.isEmpty) {
      searchFilter = deletedNotificatioNList;
      update();
    } else {
      search = deletedNotificatioNList
          .where((element) => element.title!
              .toLowerCase()
              .contains(searchEditingController.text.toLowerCase()))
          .toList();
      searchFilter = search;
      update();
    }
  }
  onChanged(String value) {
    if (value.isEmpty) {
      searchFilter = deletedNotificatioNList;
      update();
    } else {
      search = deletedNotificatioNList
          .where((element) =>
              element.title!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      searchFilter = search;
      update();
    }
  }

  refreshDatabase() async {
    deletedNotificatioNList.clear();
    List<NotificationDdModel> notificationDd = await DeletedNotificationDatabase
        .deletednotificationDatabase
        .queryDeletedNotification();
    if (notificationDd.isNotEmpty) {
      deletedNotificatioNList.addAll(notificationDd);
      update();
      return deletedNotificatioNList;
    }
    update();
  }
}
