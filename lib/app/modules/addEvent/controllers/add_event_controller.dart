import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:reminder/app/routes/app_pages.dart';

class AddEventController extends GetxController {
  //TODO: Implement AddEventController

  final count = 0.obs;
  List<DateTime> dateTimeList = [];
  late final DashboardController dashboardController;
  List<CalendarEvent> calendarEvents = [];

  @override
  void onInit() {
    super.onInit();
    dashboardController = Get.put(DashboardController());
  }

  void increment() => count.value++;
  getTime(String val) async {
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm");
    var formatedDateTime = (format.parse(val));
    dateTimeList.add(formatedDateTime);
    update();
  }

  checkOnTap() {
    calendarEvents.add(
      CalendarEvent(
        title: "bhat khanu cha",
        eventType: CalendarEventType.custom,
        date: DateTime.now(),
      ),
    );
    update();
    Get.back(result: {"calendarEvents": calendarEvents});
  }
}
