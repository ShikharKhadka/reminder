import 'dart:developer';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reminder/app/data/google_calendar_api.dart';
import 'package:reminder/app/data/holiday.dart';
import 'package:reminder/app/modules/database/get_storage.dart';

import 'package:reminder/app/modules/database/notification_db.dart';
import 'package:reminder/app/routes/app_pages.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/notification_db_model.dart';

class DashboardController extends GetxController {
  List<NotificationDdModel> notificationDbList = [];
  bool isLoading = false;
  List<Holiday> holidays = [];
  late DateTime focusedDate;
  late DateTime selectedDate;
  List<Holiday> selectedEvents = [];
  late String event;
  late CalendarFormat calendarFormat;
  @override
  void onInit() async {
    await getHolidays();
    await getNotificationDb();
    focusedDate = DateTime.now();
    selectedDate = DateTime.now();
    onDateSelected(selectedDate, focusedDate);
    calendarFormat = CalendarFormat.month;
    super.onInit();
  }

  Future<void> getHolidays() async {
    isLoading = true;
    try {
      // if (HolidayStorage.readHoliday.isEmpty) {
      final results = await GoogleCalendarApi().getResult();
      if (results != null) {
        log(results.toString());
        // HolidayStorage.saveHoliday(results);
        holidays.addAll(results);
        update();
      }
      isLoading = false;
      update();
      // }
      // else {
      //   holidays = HolidayStorage.readHoliday;
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<List<NotificationDdModel>> getNotificationDb() async {
    isLoading = true;
    List<NotificationDdModel> notificationDd =
        await NotificationDatabase.notificationDatabase.queryNotification();
    await Future.delayed(const Duration(seconds: 3));
    if (notificationDd.isNotEmpty) {
      notificationDbList.addAll(notificationDd);
      update();
      return notificationDbList;
    }
    isLoading = false;
    update();
    return notificationDd;
  }

  refreshDb() async {
    notificationDbList.clear();
    List<NotificationDdModel> notificationDd =
        await NotificationDatabase.notificationDatabase.queryNotification();
    if (notificationDd.isNotEmpty) {
      notificationDbList.addAll(notificationDd);
      update();
      return notificationDbList;
    }
    update();
  }

  floatingButtonOnPressed() async {
    Map<String, List<NotificationDdModel>> result =
        await Get.toNamed(Routes.home);
    result.forEach((key, value) => notificationDbList.assignAll(value));
    update();
  }

  List<Holiday> eventLoader(DateTime dateTime) {
    return holidays
        .where((element) => isSameDay(dateTime, element.date))
        .toList();
  }

  bool selectedDatePredicate(DateTime date) {
    return isSameDay(date, selectedDate);
  }

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedEvents.clear();
    selectedDate = selected;
    focusedDate = focused;
    final eventsToday = eventLoader(selectedDate);
    if (eventsToday.isNotEmpty) {
      for (var element in eventsToday) {
        selectedEvents.add(element);
        event = element.title;
        update();
      }
    }
    update();
  }

  bool holidayPredict(DateTime dateTime) {
    return holidays.any((element) => isSameDay(dateTime, element.date));
  }

  void onFormatChange(CalendarFormat updatedCalendarFormat) {
    calendarFormat = updatedCalendarFormat;
    update();
  }
}
