import 'package:flutter/material.dart';
import 'package:task_planner/models/reminder_model.dart';
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
List<String> defaultTemplateIcon = [
  "🚰",
  "🏋️‍♂️",
  "📘",
  "🌌",
  "🧡",
  "🧋",
  "👪🏻",
  "💊",
  "😊",
  "🛒",
  "🧘🏻‍♂️",
  "🎧",
  "🛁",
  "🚶‍♂️"
];

List<String> defaultTemplates = [
  "Drink water, keep healthy",
  "Go exercise",
  "Keep reading",
  "Go to bed early",
  "Be grateful for what you have",
  "Take a break",
  "Keep in touch with family",
  "Take pill reminder",
  "Practice smiling and be happy",
  "Go shopping",
  "Meditate for 10 minutes",
  "Listen to a podcast or audiobook",
  "Indulge in a relaxing bath",
  "Take a mindful walk"
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

  static ReminderModel getExactDateTimeOfrepeat(ReminderModel reminderItem) {
    ReminderModel repeatTaskItem = reminderItem;

    DateTime exactRepeatTime = Dates.getDateTimeFromDateAndTime(
        reminderItem.date!, reminderItem.completionTime!);
    switch (reminderItem.repeat) {
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
        exactRepeatTime = DateTime(
            exactRepeatTime.year,
            exactRepeatTime.month + 1,
            exactRepeatTime.day,
            exactRepeatTime.hour,
            exactRepeatTime.minute);

        repeatTaskItem.isCompleted = false;
        repeatTaskItem.date = exactRepeatTime.toString().substring(0, 10);
        return repeatTaskItem;
      case "Annually":
        exactRepeatTime = DateTime(
            exactRepeatTime.year + 1,
            exactRepeatTime.month,
            exactRepeatTime.day,
            exactRepeatTime.hour,
            exactRepeatTime.minute);
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
