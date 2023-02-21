import 'dart:core';

import 'package:get_storage/get_storage.dart';
import 'package:reminder/app/data/holiday.dart';

class HolidayStorage {
  static GetStorage localStorage = GetStorage('holiday');

  static void saveHoliday(List<Holiday> holidayList) {
    List<Map<String, dynamic>> listToStore =
        holidayList.map((e) => e.toMap()).toList();
    localStorage.write('holidayList', listToStore);
  }

  static List<Holiday> get readHoliday {
    if (localStorage.hasData('holidayList')) {
      List<Map<String, dynamic>> storedList = localStorage.read('holidayList');
      List<Holiday> listToReturn =
          storedList.map((e) => Holiday.fromMap(e)).toList();
      //return jsonDecode(localStorage.read('holidayList'));
      return listToReturn;
    } else {
      return [];
    }
  }

  static void removeStorage() {
    localStorage.remove('holidayList');
  }
}
