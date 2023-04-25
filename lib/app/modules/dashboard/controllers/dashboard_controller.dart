// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:get/get.dart';
import 'package:reminder/app/locator/locator.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:reminder/app/data/google_calendar_api.dart';
import 'package:reminder/app/modules/database/deleted_notification_db.dart';
import 'package:reminder/app/modules/database/notification_db.dart';
import 'package:reminder/app/routes/app_pages.dart';

import '../../model/notification_db_model.dart';

enum CalendarEventType {
  holidayNepal(displayName: "National Holiday"),
  holidayUsa(displayName: "International Holdiay"),
  custom(displayName: "");

  final String displayName;
  const CalendarEventType({required this.displayName});
}

extension CalendarEventTypeX on CalendarEventType {
  bool get isHoliday =>
      this == CalendarEventType.holidayNepal ||
      this == CalendarEventType.holidayUsa;
}

class CalendarEvent {
  final String title;
  final CalendarEventType eventType;
  final DateTime date;
  CalendarEvent({
    required this.title,
    required this.eventType,
    required this.date,
  });
}

class DashboardController extends GetxController {
  final GoogleCalendarApi _googleApi = locator.get<GoogleCalendarApi>();

  List<NotificationDdModel> notificationDbList = [];
  bool isLoading = false;
  List<CalendarEvent> calendarEvents = [];
  late DateTime focusedDate;
  late DateTime selectedDate;
  List<CalendarEvent> selectedEvents = [];
  late CalendarFormat calendarFormat;

  List<CalendarEventType> calendarEventTypesForDay = [];
  @override
  void onInit() async {
    focusedDate = DateTime.now();
    selectedDate = DateTime.now();
    calendarFormat = CalendarFormat.month;
    await getHolidays();
    await getNotificationDb();
    onDateSelected(selectedDate, focusedDate);
    super.onInit();
  }

  Future<void> getHolidays() async {
    isLoading = true;
    try {
      // if (HolidayStorage.readHoliday.isEmpty) {
      final npResults = await _googleApi.getResult(Country.nepal);
      final usaResults = await _googleApi.getResult(Country.america);
      if (npResults != null && usaResults != null) {
        for (var nepHoliday in npResults) {
          calendarEvents.add(
            CalendarEvent(
              title: nepHoliday.title,
              eventType: CalendarEventType.holidayNepal,
              date: nepHoliday.date,
            ),
          );
        }
        for (var engHoliday in usaResults) {
          calendarEvents.add(CalendarEvent(
            title: engHoliday.title,
            eventType: CalendarEventType.holidayUsa,
            date: engHoliday.date,
          ));
        }
      }

      // calendarEvents.add(
      //   CalendarEvent(
      //       title: "bhat khanu cha",
      //       eventType: CalendarEventType.custom,
      //       date: DateTime.now()),
      // );
      isLoading = false;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<List<NotificationDdModel>> getNotificationDb() async {
    isLoading = true;
    List<NotificationDdModel> notificationDd =
        await NotificationDatabase.notificationDatabase.queryNotification();
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
    isLoading = true;
    List<NotificationDdModel> notificationDd =
        await NotificationDatabase.notificationDatabase.queryNotification();
    if (notificationDd.isNotEmpty) {
      notificationDbList.addAll(notificationDd);
      update();
      return notificationDbList;
    }
    isLoading = false;
    update();
  }

  floatingButtonOnPressed() async {
    Map<String, List<NotificationDdModel>> result =
        await Get.toNamed(Routes.home);
    result.forEach((key, value) => notificationDbList.assignAll(value));

    update();
  }

  List<CalendarEvent> eventLoader(DateTime dateTime) {
    return calendarEvents
        .where((element) => isSameDay(dateTime, element.date))
        .toList();
  }

  List<CalendarEvent> filterEvents({required CalendarEventType eventType}) {
    return selectedEvents
        .where((element) => element.eventType == eventType)
        .toList();
  }

  bool selectedDatePredicate(DateTime date) {
    return isSameDay(date, selectedDate);
  }

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedEvents.clear();
    calendarEventTypesForDay.clear();
    selectedDate = selected;
    focusedDate = focused;
    selectedEvents = eventLoader(selectedDate);
    for (var type in CalendarEventType.values) {
      if (filterEvents(eventType: type).isNotEmpty) {
        calendarEventTypesForDay.add(type);
      }
    }
    update();
  }

  bool holidayPredicate(DateTime dateTime) {
    return calendarEvents.any(
      (event) => isSameDay(dateTime, event.date) && event.eventType.isHoliday,
    );
  }

  void onFormatChange(CalendarFormat updatedCalendarFormat) {
    calendarFormat = updatedCalendarFormat;
    update();
  }

  Future<void> floatingDeletedButtonOnPressed() async {
    Get.toNamed(Routes.DELETE);
  }

  void floatingAddEventsButtonOnPressed() async {
    Map<String, List<CalendarEvent>> result =
        await Get.toNamed(Routes.ADD_EVENT);
    result.forEach((key, value) => calendarEvents.assignAll(value));
    update();
  }

  insertIntoDeletedDB(
      {required dateTime,
      required title,
      required description,
      required notificationId}) {
    DeletedNotificationDatabase.deletednotificationDatabase
        .insertDeletedNotification({
      'dateTimeList': dateTime,
      'title': title,
      'description': description,
      'notificationId': notificationId
    });
  }
}
