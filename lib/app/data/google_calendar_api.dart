import 'package:dio/dio.dart';
import 'package:reminder/app/data/holiday.dart';

class GoogleCalendarApi {
  String url =
      'https://www.googleapis.com/calendar/v3/calendars/en.np%23holiday%40group.v.calendar.google.com/events';
  String apiKey = 'AIzaSyD_ADwDDHZPs87g6nI42gYbH6XkBYRUtP8';
  Dio dio = Dio();
  Future<List<Holiday>?> getResult() async {
    var response = await dio.get(url, queryParameters: {"key": apiKey});
    if (response.statusCode == 200) {
      final decodedResponse = response.data;
      final decodedHolidays = List<Holiday>.from(
        decodedResponse["items"].map(
          (e) => Holiday.fromMap(e),
        ),
      );
      return decodedHolidays;
    } else {
      return null;
    }
  }
}
