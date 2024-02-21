import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:task_planner/models/task_planner_model.dart';
import 'package:task_planner/models/reminder_model.dart';
import 'package:task_planner/models/to_do_model.dart';

import '../../models/enum_models.dart';
import '../../services/notification_service.dart';
import '../../utils/dates/date_time.dart';

class SQLHelper {
  // creating a db
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      "test_1.db",
      version: 1,
      onCreate: (db, version) async {
        if (kDebugMode) {
          print("Creating a table...");
        }
        await ReminderSQLHelper.createTable(db);
        await ToDoSQLHelper.createTable(db);
        await TaskPlannerHelper.createTable(db);
      },
    );
  }
}

class ReminderSQLHelper {
  static const reminderTableName = "ReminderTable";
  //creating a table to store data
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
        CREATE TABLE $reminderTableName( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT,
        date TEXT,
        isCompleted BOOL,
        completionTime TEXT,
        category TEXT,
        reminder TEXT,
        repeat TEXT
        )""");
  }

  // to add a new item to db, conflict algo -> if conflict arises what would be the reaction
  static Future<int> createItem(ReminderModel reminderItem) async {
    final db = await SQLHelper.db();
    final data = reminderItem.toJson();
    int id = await db.insert(reminderTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    DateTime notifDateTime = Dates.getDateTimeFromDateAndTime(
        reminderItem.date!, reminderItem.completionTime!);
    String body = "Reminder - ";
    body = body + DateFormat("d MMM, hh:mm").format(notifDateTime);
    await NotificationService().scheduleNotif(
        id: id,
        title: reminderItem.title,
        body: body,
        scheduledNotifDateTime: Models.getExactDateTimeForNotif(
            notifDateTime, reminderItem.reminder!));
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllToDoItems() async {
    final db = await SQLHelper.db();
    return db.query(reminderTableName);
  }

  // the listview will be decoded by this
  static Future<List<Map<String, dynamic>>> getListByDay(String date) async {
    final db = await SQLHelper.db();
    return db.query(reminderTableName, where: "date=?", whereArgs: [date]);
  }

  static Future<List<Map<String, dynamic>>> getListByCategory(
      String category) async {
    final db = await SQLHelper.db();
    return db
        .query(reminderTableName, where: "category=?", whereArgs: [category]);
  }

  static Future<void> updateItem(ReminderModel reminderItem) async {
    final db = await SQLHelper.db();
    final data = reminderItem.toJson();
    await db.update(reminderTableName, data,
        where: "id=?", whereArgs: [reminderItem.id]);
    await NotificationService()
        .cancelNotif(id: reminderItem.id!)
        .onError((error, stackTrace) => null);
    DateTime notifDateTime = Dates.getDateTimeFromDateAndTime(
        reminderItem.date!, reminderItem.completionTime!);
    String body = "Reminder - ";
    body = body + DateFormat("d MMM, hh:mm").format(notifDateTime);
    await NotificationService()
        .scheduleNotif(
            id: reminderItem.id!,
            title: reminderItem.title,
            body: body,
            scheduledNotifDateTime: Models.getExactDateTimeForNotif(
                notifDateTime, reminderItem.reminder!))
        .onError((error, stackTrace) => null);
  }

  static Future<void> updateCheckBoxItem(ReminderModel reminderItem) async {
    final db = await SQLHelper.db();
    final data = reminderItem.toJson();

    await db.update(reminderTableName, data,
        where: "id=?", whereArgs: [reminderItem.id]);
    if (reminderItem.isCompleted == true) {
      await NotificationService()
          .cancelNotif(id: reminderItem.id!)
          .then((value) async {
        if (reminderItem.repeat != "Never") {
          await ReminderSQLHelper.deleteItem(reminderItem);

          await ReminderSQLHelper.createItem(
              Models.getExactDateTimeOfrepeat(reminderItem));
        }
      }).onError((error, stackTrace) => null);
    } else {
      DateTime notifDateTime = Dates.getDateTimeFromDateAndTime(
          reminderItem.date!, reminderItem.completionTime!);
      String body = "Reminder - ";
      body = body + DateFormat("d MMM, hh:mm").format(notifDateTime);
      await NotificationService()
          .scheduleNotif(
              id: reminderItem.id!,
              title: reminderItem.title,
              body: body,
              scheduledNotifDateTime: Models.getExactDateTimeForNotif(
                  notifDateTime, reminderItem.reminder!))
          .onError((error, stackTrace) {});
    }
  }

  static Future<void> deleteItem(ReminderModel reminderItem) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(reminderTableName,
          where: "id=?", whereArgs: [reminderItem.id]);
      await NotificationService().cancelNotif(id: reminderItem.id!);
    } catch (e) {
      rethrow;
    }
  }
}

class ToDoSQLHelper {
  static const todoTableName = "ToDoTable";
  //creating a table to store data
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
        CREATE TABLE $todoTableName( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT,
        date TEXT,
        isCompleted BOOL
        )""");
  }

  // to add a new item to db, conflict algo -> if conflict arises what would be the reaction
  static Future<int> createItem(ToDoModel todoItem) async {
    final db = await SQLHelper.db();
    final data = todoItem.toJson();
    int id = await db.insert(todoTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllToDoItems() async {
    final db = await SQLHelper.db();
    return db.query(todoTableName);
  }

  // the listview will be decoded by this
  static Future<List<Map<String, dynamic>>> getListByDay(String date) async {
    final db = await SQLHelper.db();
    return db.query(todoTableName, where: "date=?", whereArgs: [date]);
  }

  static Future<void> updateItem(ToDoModel todoItem) async {
    final db = await SQLHelper.db();
    final data = todoItem.toJson();
    await db
        .update(todoTableName, data, where: "id=?", whereArgs: [todoItem.id]);
  }

  static Future<void> updateCheckBoxItem(ToDoModel todoItem) async {
    final db = await SQLHelper.db();
    final data = todoItem.toJson();

    await db
        .update(todoTableName, data, where: "id=?", whereArgs: [todoItem.id]);
  }

  static Future<void> deleteItem(ToDoModel todoItem) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(todoTableName, where: "id=?", whereArgs: [todoItem.id]);
    } catch (e) {
      rethrow;
    }
  }
}

class TaskPlannerHelper {
  static const taskPlannertable = "TaskPlanner";
  //creating a table to store data
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
        CREATE TABLE $taskPlannertable( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT,
        date TEXT,
        description TEXT,
        startTime TEXT,
        endTime TEXT,
        hexColorCode TEXT,
        category TEXT
        )""");
  }

  static Future<void> createItem(TaskPlanner taskItem) async {
    final db = await SQLHelper.db();

    final data = taskItem.toJson();
    await db.insert(taskPlannertable, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getListByDay(String date) async {
    final db = await SQLHelper.db();
    return db.query(taskPlannertable, where: "date=?", whereArgs: [date]);
  }

  static Future<void> deleteItem(TaskPlanner taskItem) async {
    final db = await SQLHelper.db();

    try {
      await db
          .delete(taskPlannertable, where: "id=?", whereArgs: [taskItem.id]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateItem(TaskPlanner taskPlanner) async {
    final db = await SQLHelper.db();
    final data = taskPlanner.toJson();

    await db.update(taskPlannertable, data,
        where: "id=?", whereArgs: [taskPlanner.id]);
  }
}
