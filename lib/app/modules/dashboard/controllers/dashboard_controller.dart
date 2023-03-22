
import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:get/get.dart';

import 'package:reminder/app/data/google_calendar_api.dart';
import 'package:reminder/app/data/holiday.dart';

import 'package:reminder/app/modules/database/notification_db.dart';
import 'package:reminder/app/routes/app_pages.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/notification_db_model.dart';

class DashboardController extends GetxController {
  List<NotificationDdModel> notificationDbList = [];
  bool isLoading = false;
  List<Holiday> holidays = [];
  List<Holiday> nepaliCalendarholidays = [];
  late DateTime focusedDate;
  late DateTime selectedDate;
  List<Holiday> selectedEvents = [];
  late String event;
  late CalendarFormat calendarFormat;
  List<bool> selectedButton = [true, false];
  bool showCalendar = false;
  late NepaliDateTime neplaiCalendarSelectedDate;
  bool nepaliCalendarOnHolidaySelected = false;
  late NepaliCalendarController nepaliCalendarController;

  @override
  void onInit() async {
    nepaliCalendarController = NepaliCalendarController();
    await getHolidays();
    await getNotificationDb();
    focusedDate = DateTime.now();
    selectedDate = DateTime.now();
    calendarFormat = CalendarFormat.month;
    neplaiCalendarSelectedDate = NepaliDateTime.now();

    super.onInit();
  }

  Future<void> getHolidays() async {
    isLoading = true;
    try {
      // if (HolidayStorage.readHoliday.isEmpty) {
      final results = await GoogleCalendarApi().getResult();
      if (results != null) {
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

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedEvents.clear();
    selectedDate = selected;
    update();
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

  bool seletedDayPredicted(DateTime dateTime) {
    return isSameDay(dateTime, selectedDate);
  }

  selectedButtonOnTap(int value) {
    for (int i = 0; i < selectedButton.length; i++) {
      // selectedButton[i] = i == value;
      // update();
      if (i == value) {
        selectedButton[i] = true;
        showCalendar = true;
        update();
      } else {
        selectedButton[i] = false;
        showCalendar = false;
        update();
      }
    }
  }

  List<Holiday> nepaliEventPredict(NepaliDateTime nepaliDateTime) {
    return holidays
        .where((element) =>
            isSameDay(nepaliDateTime, element.date.toNepaliDateTime()))
        .toList();
  }

  int nepaliEventPredictListLength(NepaliDateTime nepaliDateTime) {
    final holidayList = holidays
        .where((element) =>
            isSameDay(nepaliDateTime, element.date.toNepaliDateTime()))
        .toList();
    return holidayList.length;
  }

  bool nepaliHolidayPredict(NepaliDateTime nepaliDateTime) {
    return holidays.any((element) =>
        isSameDay(nepaliDateTime, element.date.toNepaliDateTime()));
  }

  onDateChanged(NepaliDateTime nepDate) {
    selectedDate = nepDate.toDateTime();
    neplaiCalendarSelectedDate = nepDate;
    update();
    nepaliCalendarholidays.clear();
    if (nepDate.weekday == 7 ||
        holidays.any((element) => isSameDay(
            neplaiCalendarSelectedDate, element.date.toNepaliDateTime()))) {
      !nepaliCalendarOnHolidaySelected;
      update();
    }
    nepaliCalendarOnHolidaySelected;
    final eventList = nepaliEventPredict(neplaiCalendarSelectedDate);
    update();
    if (eventList.isNotEmpty) {
      for (var element in eventList) {
        nepaliCalendarholidays.add(element);
        update();
      }
    }
  }
}
