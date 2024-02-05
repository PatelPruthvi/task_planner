import 'package:flutter/material.dart';
import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/utils/dates/date_time.dart';

List<String> categories = ["None", "Work", "Personal", "Wishlist", "Birthday"];
List<String> reminders = [
  "Same with due date",
  "5 minutes before",
  "10 minutes before",
  "15 minutes before",
  "30 minutes before",
  "1 hour before",
  "1 day before"
];
List<String> repeats = [
  "Never",
  "Hourly",
  "Daily",
  "Weekly",
  "Monthly",
  "Annually"
];

enum Category { none, work, personal, wishlist, birthday }

enum Reminder {
  fiveMinutesEarlier,
  tenMinutesEarlier,
  fifteenMinutesEarlier,
  thirtyMinutesEarlier,
  oneHourEarlier,
  oneDayEarlier,
  sameTime
}

class Models {
  static String getCategory(Category category) {
    switch (category) {
      case Category.none:
        return "None";
      case Category.birthday:
        return "Birthday";
      case Category.personal:
        return "Personal";
      case Category.wishlist:
        return "Wishlist";
      case Category.work:
        return "Work";
      default:
        return "None";
    }
  }

  static String getReminder(Reminder reminder) {
    switch (reminder) {
      case Reminder.fiveMinutesEarlier:
        return "5 minutes before";
      case Reminder.tenMinutesEarlier:
        return "10 minutes before";
      case Reminder.fifteenMinutesEarlier:
        return "15 minutes before";
      case Reminder.thirtyMinutesEarlier:
        return "30 minutes before";
      case Reminder.sameTime:
        return "Same with due date";
      case Reminder.oneHourEarlier:
        return "1 hour before";
      case Reminder.oneDayEarlier:
        return "1 day before";
      default:
        return "5 minutes before";
    }
  }

  static ToDo getExactDateTimeOfrepeat(ToDo todoItem) {
    ToDo repeatTaskItem = todoItem;

    DateTime exactRepeatTime = Dates.getDateTimeFromDateAndTime(
        todoItem.date!, todoItem.completionTime!);
    switch (todoItem.repeat) {
      case "Never":
        return repeatTaskItem;
      case "Hourly":
        exactRepeatTime = exactRepeatTime.add(const Duration(hours: 1));
        repeatTaskItem.isCompleted = false;
        repeatTaskItem.date = exactRepeatTime.toString().substring(0, 10);
        repeatTaskItem.completionTime = TimeOfDay.fromDateTime(exactRepeatTime)
            .toString()
            .substring(10, 15);
        return repeatTaskItem;

      case "Daily":
        exactRepeatTime = exactRepeatTime.add(const Duration(days: 1));
        repeatTaskItem.isCompleted = false;
        repeatTaskItem.date = exactRepeatTime.toString().substring(0, 10);
        return repeatTaskItem;
      case "Weekly":
        exactRepeatTime = exactRepeatTime.add(const Duration(days: 7));
        repeatTaskItem.isCompleted = false;
        repeatTaskItem.date = exactRepeatTime.toString().substring(0, 10);
        return repeatTaskItem;
      case "Monthly":
        exactRepeatTime = exactRepeatTime.add(const Duration(days: 30));
        repeatTaskItem.isCompleted = false;
        repeatTaskItem.date = exactRepeatTime.toString().substring(0, 10);
        return repeatTaskItem;
      case "Annually":
        exactRepeatTime = exactRepeatTime.add(const Duration(days: 365));
        repeatTaskItem.isCompleted = false;
        repeatTaskItem.date = exactRepeatTime.toString().substring(0, 10);
        return repeatTaskItem;
      default:
        return repeatTaskItem;
    }
  }

  static getExactDateTimeForNotif(DateTime dateTime, String reminderTime) {
    DateTime exactTime;
    switch (reminderTime) {
      case "Same with due date":
        return dateTime;
      case "5 minutes before":
        exactTime = dateTime.subtract(const Duration(minutes: 5));
        return exactTime;
      case "10 minutes before":
        exactTime = dateTime.subtract(const Duration(minutes: 10));
        return exactTime;
      case "15 minutes before":
        exactTime = dateTime.subtract(const Duration(minutes: 15));
        return exactTime;
      case "30 minutes before":
        exactTime = dateTime.subtract(const Duration(minutes: 30));
        return exactTime;
      case "1 hour before":
        exactTime = dateTime.subtract(const Duration(minutes: 60));
        return exactTime;
      case "1 day before":
        exactTime = dateTime.subtract(const Duration(days: 1));
        return exactTime;
      default:
        return dateTime;
    }
  }
}
