import 'package:dio/dio.dart';
import 'package:reminder/app/base_client.dart/base_client.dart';
import 'package:reminder/app/data/holiday.dart';
import 'package:reminder/app/endpoints/api_endpoints.dart';

enum Country {
  america(code: "en.usa"),
  nepal(code: "en.np");

  final String code;
  const Country({required this.code});
}

class GoogleCalendarApi {
  BaseClient baseClient = BaseClient();
  String apiKey = 'AIzaSyD_ADwDDHZPs87g6nI42gYbH6XkBYRUtP8';
  Dio dio = Dio();
  Future<List<Holiday>?> getResult(Country country) async {
    var response = await baseClient.dio.get(
        '${country.code}${ApiEndpoints.holiday}',
        queryParameters: {"key": apiKey});
    if (response.statusCode == 200 || response.statusCode == 304) {
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
