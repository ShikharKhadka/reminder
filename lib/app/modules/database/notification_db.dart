import 'dart:async';
import 'dart:developer';


import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:reminder/app/modules/model/notification_db_model.dart';

class NotificationDatabase {
  static NotificationDatabase notificationDatabase =
      NotificationDatabase._privateConstructor();
  NotificationDatabase._privateConstructor();
  Database? _database;

  static const String tableUser = 'notificationTable';

  static const String columnTableId = 'tableId';
  static const String columnNotificationId = 'notificationId';
  static const String columnDateTimeList = 'dateTimeList';
  static const String columnTitle = 'title';
  static const String columnDesc = 'description';

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }
  initDB() async {
    var dir = await getExternalStorageDirectory();
    final path = join(dir!.path, 'notification.db');
    print(path);
    return await openDatabase(path, version: 1, readOnly: false,
        onCreate: (Database db, int version) async {
      log("============Creating user notification table=========");
      await db.execute("CREATE TABLE $tableUser("
          "$columnTableId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$columnNotificationId INTEGER NOT NULL,"
          "$columnDateTimeList TEXT NOT NULL,"
          "$columnTitle TEXT NOT NULL,"
          "$columnDesc TEXT NOT NULL)");
    });
  }
  // }

  Future<int?> insertNotification(Map<String, dynamic> bookMark) async {
    final db = await database;
    log("database ===== ${db.toString()}");
    return await db?.insert(
      tableUser,
      bookMark,
    );
  }

  List<NotificationDdModel> notificationQuery = [];

  Future<List<NotificationDdModel>> queryNotification() async {
    final db = await database;
    var notification = await db!.query(tableUser, distinct: true);

    notificationQuery = notification.isNotEmpty
        ? notification.map((e) => NotificationDdModel?.fromJson(e)).toList()
        : [];

    return notificationQuery;
  }

  Future<int?> deleteNotification(int? id) async {
    final db = await database;
    return await db!
        .delete(tableUser, where: 'notificationId IN (?)', whereArgs: [id]);
  }

  clearTable() async {
    final db = await database;
    db?.delete(tableUser);
  }
}
