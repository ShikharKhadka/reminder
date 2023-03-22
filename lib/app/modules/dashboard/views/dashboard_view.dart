
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:reminder/app/data/holiday.dart';
import 'package:reminder/app/modules/database/notification_db.dart';
import 'package:reminder/app/utils/app_theme.dart';
import 'package:reminder/notification/notification_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
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
          body: controller.notificationDbList.isEmpty
              ? controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(child: Icon(Icons.notification_add_outlined)),
                        Text(
                          'Add Reminder',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    ToggleButtons(
                      fillColor: AppTheme.primaryColor,
                      isSelected: controller.selectedButton,
                      selectedColor: Colors.white,
                      splashColor: AppTheme.primaryColor,
                      onPressed: controller.selectedButtonOnTap,
                      children: const [
                        Text('English'),
                        Text('Nepali'),
                      ],
                    ),
                    Card(
                      child: controller.showCalendar
                          ? picker.CalendarDatePicker(
                              initialDate:
                                  controller.selectedDate.toNepaliDateTime(),
                              firstDate: NepaliDateTime(2000),
                              lastDate: NepaliDateTime(2090),
                              onDateChanged: controller.onDateChanged,
                              todayDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor.withOpacity(0.5),
                              ),
                              selectedDayDecoration:
                                  controller.nepaliHolidayPredict(controller
                                          .selectedDate
                                          .toNepaliDateTime())
                                      ? const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primaryColor)
                                      : const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primaryColor),
                              dayBuilder: (dayToBuild) {
                                return Stack(
                                  children: <Widget>[
                                    Center(
                                      child: dayToBuild.weekday == 7 ||
                                              controller.holidays.any(
                                                  (element) => isSameDay(
                                                      element.date
                                                          .toNepaliDateTime(),
                                                      dayToBuild))
                                          ? Text(
                                              NepaliUnicode.convert(
                                                  '${dayToBuild.day}'),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )
                                          : Text(
                                              NepaliUnicode.convert(
                                                  '${dayToBuild.day}'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                    ),
                                    // if (controller.holidays.any(
                                    //   (event) {
                                    //     return isSameDay(dayToBuild,
                                    //         event.date.toNepaliDateTime());
                                    //   },
                                    // ))
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: List.generate(
                                    //     controller
                                    //         .nepaliEventPredictListLength(
                                    //             dayToBuild),
                                    //     (index) => Align(
                                    //       alignment: Alignment.bottomCenter,
                                    //       child: Container(
                                    //         width: 6,
                                    //         height: 6,
                                    //         decoration: const BoxDecoration(
                                    //             shape: BoxShape.circle,
                                    //             color: Colors.purple),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                );
                              },
                            )
                          : TableCalendar(
                              focusedDay: controller.selectedDate,
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
                              selectedDayPredicate:
                                  controller.seletedDayPredicted,
                              onDaySelected: controller.onDateSelected,
                              eventLoader: controller.eventLoader,
                              holidayPredicate: controller.holidayPredict,
                              daysOfWeekHeight: 16,
                              calendarBuilders: CalendarBuilders(
                                outsideBuilder: (context, day, focusedDay) =>
                                    const SizedBox(),
                                selectedBuilder: (context, day, focusedDay) {
                                  if (controller.holidayPredict(day) ||
                                      day.weekday == DateTime.saturday) {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.red,
                                                  width: 1.4)),
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Text(day.day.toString())),
                                    );
                                  } else {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: const BoxDecoration(
                                          color: AppTheme.primaryColor,
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: AppTheme.primaryColor,
                                                  width: 1.4)),
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Text(day.day.toString())),
                                    );
                                  }
                                },
                                todayBuilder: (context, day, focusedDay) {
                                  if (controller.holidayPredict(day) ||
                                      day.weekday == DateTime.saturday) {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.5),
                                          border: const Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.red,
                                                  width: 1.4)),
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Text(day.day.toString())),
                                    );
                                  } else {
                                    return Container(
                                      margin: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.3),
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: AppTheme.primaryColor
                                                      .withOpacity(0.3),
                                                  width: 1.4)),
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Text(day.day.toString())),
                                    );
                                  }
                                },
                                markerBuilder:
                                    (context, day, List<Holiday> events) {
                                  if (controller.holidays.any((element) =>
                                      isSameDay(day, element.date))) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        events.length,
                                        (index) => Container(
                                          height: 10,
                                          width: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              calendarStyle: const CalendarStyle(
                                weekendTextStyle: TextStyle(color: Colors.red),
                                holidayTextStyle: TextStyle(color: Colors.red),
                                holidayDecoration: BoxDecoration(
                                    border: Border.fromBorderSide(BorderSide(
                                        color: Colors.red, width: 1.4)),
                                    shape: BoxShape.circle),
                              ),
                            ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.nepaliCalendarholidays.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Event',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Center(
                                    child: Text(
                                      controller
                                          .nepaliCalendarholidays[index].title,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            notification.title!,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                await NotificationService()
                                                    .flutterLocalNotificationsPlugin
                                                    .cancel(controller
                                                        .notificationDbList[
                                                            index]
                                                        .notificationId!);
                                                await NotificationDatabase
                                                    .notificationDatabase
                                                    .deleteNotification(
                                                        controller
                                                            .notificationDbList[
                                                                index]
                                                            .notificationId);
                                                await controller.refreshDb();
                                              },
                                              icon: const Icon(Icons.delete)),
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
                            }),
                      ],
                    ),
                  ],
                )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppTheme.primaryColor,
            onPressed: controller.floatingButtonOnPressed,
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
