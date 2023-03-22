import 'dart:convert';

class NotificationDdModel {
  NotificationDdModel({
    required this.notificationId,
    required this.dateTimeList,
    required this.title,
    required this.description,
  });

  final int? notificationId;
  final String? dateTimeList;
  final String? title;
  final String? description;

  factory NotificationDdModel.fromRawJson(String str) =>
      NotificationDdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationDdModel.fromJson(Map<String, dynamic> json) =>
      NotificationDdModel(
        notificationId: json["notificationId"],
        dateTimeList: json["dateTimeList"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "dateTimeList": dateTimeList,
        "title": title,
        "description": description,
      };
}

class CalendarModel {
  CalendarModel({
    required this.notificationId,
    required this.dateTimeList,
    required this.title,
    required this.description,
  });

  final int? notificationId;
  final String? dateTimeList;
  final String? title;
  final String? description;

  factory CalendarModel.fromRawJson(String str) =>
      CalendarModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalendarModel.fromJson(Map<String, dynamic> json) =>
      CalendarModel(
        notificationId: json["notificationId"],
        dateTimeList: json["dateTimeList"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "dateTimeList": dateTimeList,
        "title": title,
        "description": description,
      };
}