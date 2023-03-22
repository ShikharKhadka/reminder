import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class Holiday {
  final String title;
  final DateTime date;

  Holiday({required this.title, required this.date});

  factory Holiday.fromMap(Map<String, dynamic> map) {
    return Holiday(
      title: map['summary'] ?? "",
      date: DateFormat('yyyy-MM-dd').parse(map['start']['date']),
    );
  }

  factory Holiday.fromJson(String source) =>
      Holiday.fromMap(json.decode(source) as Map<String, dynamic>);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());
}

class NepaliHoliday {
  final String title;
  final NepaliDateTime date;

  NepaliHoliday({required this.title, required this.date});

  factory NepaliHoliday.fromMap(Map<String, dynamic> map) {
    return NepaliHoliday(
      title: map['summary'] ?? "",
      date: NepaliDateTime.parse(map['start']['date']),
    );
  }

  factory NepaliHoliday.fromJson(String source) =>
      NepaliHoliday.fromMap(json.decode(source) as Map<String, dynamic>);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'date': date.millisecondsSinceEpoch,
    };
  }
  String toJson() => json.encode(toMap());
}


