import 'dart:async';
import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:reminder/app/modules/model/notification_db_model.dart';

class DeletedNotificationDatabase {
  static DeletedNotificationDatabase deletednotificationDatabase =
      DeletedNotificationDatabase._privateConstructor();
  DeletedNotificationDatabase._privateConstructor();
  Database? _database;

  static const String tableUser = 'notificationTable';
  static const String columnTableId = 'tableId';
  static const String columnDateTimeList = 'dateTimeList';
  static const String columnNotificationId = 'notificationId';
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
    var dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'deletedNotification.db');
    return await openDatabase(path, version: 1, readOnly: false,
        onCreate: (Database db, int version) async {
      log("============Creating deleted notification table=========");
      await db.execute("CREATE TABLE $tableUser("
          "$columnTableId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$columnNotificationId INTEGER NOT NULL,"
          "$columnDateTimeList TEXT NOT NULL,"
          "$columnTitle TEXT NOT NULL,"
          "$columnDesc TEXT NOT NULL)");
    });
  }
  // }

  Future<int?> insertDeletedNotification(Map<String, dynamic> bookMark) async {
    final db = await database;
    log("database ===== ${db.toString()}");
    return await db?.insert(
      tableUser,
      bookMark,
    );
  }

  List<NotificationDdModel> deletedNotificationQuery = [];

  Future<List<NotificationDdModel>> queryDeletedNotification() async {
    final db = await database;
    var notification = await db!.query(tableUser, distinct: true);

    deletedNotificationQuery = notification.isNotEmpty
        ? notification.map((e) => NotificationDdModel?.fromJson(e)).toList()
        : [];

    return deletedNotificationQuery;
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
