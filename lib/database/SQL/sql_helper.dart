import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:task_planner/models/task_planner_model.dart';
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
        await ToDoSQLhelper.createTable(db);
        await TaskPlannerHelper.createTable(db);
      },
    );
  }
}

class ToDoSQLhelper {
  static const todoTableName = "ToDoList";
  //creating a table to store data
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
        CREATE TABLE $todoTableName( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
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
  static Future<int> createItem(ToDo todoItem) async {
    final db = await SQLHelper.db();
    final data = todoItem.toJson();
    int id = await db.insert(todoTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    DateTime notifDateTime = Dates.getDateTimeFromDateAndTime(
        todoItem.date!, todoItem.completionTime!);
    await NotificationService().scheduleNotif(
        id: id,
        title: todoItem.title,
        body: "Did you complete your task?",
        scheduledNotifDateTime:
            Models.getExactDateTimeForNotif(notifDateTime, todoItem.reminder!));
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

  static Future<List<Map<String, dynamic>>> getListByCategory(
      String category) async {
    final db = await SQLHelper.db();
    return db.query(todoTableName, where: "category=?", whereArgs: [category]);
  }

  static Future<void> updateItem(ToDo todoItem) async {
    final db = await SQLHelper.db();
    final data = todoItem.toJson();
    await db
        .update(todoTableName, data, where: "id=?", whereArgs: [todoItem.id]);
    await NotificationService().cancelNotif(id: todoItem.id!);
    DateTime notifDateTime = Dates.getDateTimeFromDateAndTime(
        todoItem.date!, todoItem.completionTime!);

    await NotificationService().scheduleNotif(
        id: todoItem.id!,
        title: todoItem.title,
        body: "Did you complete your task?",
        scheduledNotifDateTime:
            Models.getExactDateTimeForNotif(notifDateTime, todoItem.reminder!));
  }

  static Future<void> updateCheckBoxItem(ToDo todoItem) async {
    final db = await SQLHelper.db();
    final data = todoItem.toJson();

    await db
        .update(todoTableName, data, where: "id=?", whereArgs: [todoItem.id]);
    if (todoItem.isCompleted == true) {
      await NotificationService()
          .cancelNotif(id: todoItem.id!)
          .then((value) async {
        if (todoItem.repeat != "Never") {
          await ToDoSQLhelper.deleteItem(todoItem);

          await ToDoSQLhelper.createItem(
              Models.getExactDateTimeOfrepeat(todoItem));
        }
      });
    } else {
      DateTime notifDateTime = Dates.getDateTimeFromDateAndTime(
          todoItem.date!, todoItem.completionTime!);
      await NotificationService().scheduleNotif(
          id: todoItem.id!,
          title: todoItem.title,
          body: "Did you complete your task?",
          scheduledNotifDateTime: Models.getExactDateTimeForNotif(
              notifDateTime, todoItem.reminder!));
    }
  }

  static Future<void> deleteItem(ToDo toDoItem) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(todoTableName, where: "id=?", whereArgs: [toDoItem.id]);
      await NotificationService().cancelNotif(id: toDoItem.id!);
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
