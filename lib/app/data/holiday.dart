import 'dart:convert';

import 'package:intl/intl.dart';

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
