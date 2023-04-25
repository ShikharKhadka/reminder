import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder/app/modules/database/notification_db.dart';
import 'package:reminder/app/utils/app_theme.dart';
import 'package:reminder/notification/notification_service.dart';

import 'package:table_calendar/table_calendar.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: Get.put(DashboardController()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            title: const Text('Reminder'),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Card(
                child: TableCalendar(
                  focusedDay: controller.focusedDate,
                  currentDay: DateTime.now(),
                  calendarFormat: controller.calendarFormat,
                  onFormatChanged: controller.onFormatChange,
                  availableCalendarFormats: const {
                    CalendarFormat.month: "Expand",
                    CalendarFormat.twoWeeks: "Half-Compress",
                    CalendarFormat.week: "Compress",
                  },
                  weekendDays: const [DateTime.saturday],
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2050, 10, 16),
                  selectedDayPredicate: controller.selectedDatePredicate,
                  onDaySelected: controller.onDateSelected,
                  eventLoader: controller.eventLoader,
                  holidayPredicate: controller.holidayPredicate,
                  daysOfWeekHeight: 16,
                  calendarBuilders: CalendarBuilders(
                    singleMarkerBuilder: (context, day, CalendarEvent event) {
                      return event.eventType.isHoliday ? SizedBox() : null;
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      if (controller.holidayPredicate(day) ||
                          day.weekday == DateTime.saturday) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              border: Border.fromBorderSide(
                                  BorderSide(color: Colors.red, width: 1.4)),
                              shape: BoxShape.circle),
                          child: Center(child: Text(day.day.toString())),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              border: Border.fromBorderSide(BorderSide(
                                  color: AppTheme.primaryColor, width: 1.4)),
                              shape: BoxShape.circle),
                          child: Center(child: Text(day.day.toString())),
                        );
                      }
                    },
                    todayBuilder: (context, day, focusedDay) {
                      if (controller.holidayPredicate(day) ||
                          day.weekday == DateTime.saturday) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.5),
                              border: const Border.fromBorderSide(
                                  BorderSide(color: Colors.red, width: 1.4)),
                              shape: BoxShape.circle),
                          child: Center(child: Text(day.day.toString())),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              border: Border.fromBorderSide(BorderSide(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  width: 1.4)),
                              shape: BoxShape.circle),
                          child: Center(child: Text(day.day.toString())),
                        );
                      }
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.red),
                    holidayTextStyle: TextStyle(color: Colors.red),
                    holidayDecoration: BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.red, width: 1.4)),
                        shape: BoxShape.circle),
                  ),
                ),
              ),
              controller.selectedEvents.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No Event',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.calendarEventTypesForDay
                          .map(
                            (eventType) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(eventType.displayName),
                                ...controller
                                    .filterEvents(eventType: eventType)
                                    .map((e) => EventCard(
                                        title: e.title, color: Colors.red))
                              ],
                            ),
                          )
                          .toList()
                      //  Row(
                      //     children: [
                      //       const Text('Nepali Events'),
                      //       Column(
                      //         children: List.generate(
                      //             controller.selectedEvents.length,
                      //             (index) => Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(
                      //                           left: 8.0),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.end,
                      //                     children: [
                      //                       EventCard(t),
                      //                     ],
                      //                   ),
                      //                 )),
                      //       ),
                      //     ],
                      //   )

                      ),
              controller.notificationDbList.isEmpty
                  ? controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          child: Column(
                            children: const [
                              Icon(Icons.notification_add_outlined),
                              Text(
                                'Add Reminder',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Reminder List',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ListView.builder(
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.notificationDbList.length,
                          itemBuilder: (context, index) {
                            var notification =
                                controller.notificationDbList[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title!,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await NotificationService()
                                                .flutterLocalNotificationsPlugin
                                                .cancel(controller
                                                    .notificationDbList[index]
                                                    .notificationId!);
                                            await NotificationDatabase
                                                .notificationDatabase
                                                .deleteNotification(controller
                                                    .notificationDbList[index]
                                                    .notificationId);
                                            await controller.refreshDb();
                                            await controller
                                                .insertIntoDeletedDB(
                                                    dateTime: notification
                                                        .dateTimeList,
                                                    title: notification.title,
                                                    description:
                                                        notification.title,
                                                    notificationId: notification
                                                        .notificationId);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      notification.description!,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      DateFormat('EEEE, d MMM, yyyy ').format(
                                        DateTime.parse(
                                            notification.dateTimeList!),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm a ').format(
                                        DateTime.parse(
                                          notification.dateTimeList!,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: FloatingActionButton(
                    heroTag: null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppTheme.primaryColor,
                    onPressed: controller.floatingDeletedButtonOnPressed,
                    child: const Text('Deleted items', maxLines: 1),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: AppTheme.primaryColor,
                  onPressed: controller.floatingButtonOnPressed,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(
                  width: 10,
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.3,
                //   child: FloatingActionButton(
                //     heroTag: null,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10)),
                //     backgroundColor: AppTheme.primaryColor,
                //     onPressed: controller.floatingAddEventsButtonOnPressed,
                //     child: const Text('Add events', maxLines: 1),
                //   ),
                // ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        height: MediaQuery.of(context).size.height * 0.06,
        // width: MediaQuery.of(context).size.width * 0.6,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: color, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
