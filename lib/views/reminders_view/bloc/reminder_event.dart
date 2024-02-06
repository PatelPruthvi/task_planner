part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

class ReminderInitialEvent extends ReminderEvent {}

class ReminderCategoryChangedEvent extends ReminderEvent {
  final String category;

  ReminderCategoryChangedEvent({required this.category});
}

class ReminderDeleteItemPressedEvent extends ReminderEvent {
  final ToDo todoItem;
  final String category;

  ReminderDeleteItemPressedEvent(
      {required this.category, required this.todoItem});
}

class ReminderAddTaskClickedEvent extends ReminderEvent {
  final String title;
  final String category;
  final String completionTime;
  final String reminderTime;
  final String date;
  final String repeat;

  ReminderAddTaskClickedEvent({
    required this.title,
    required this.category,
    required this.completionTime,
    required this.reminderTime,
    required this.date,
    required this.repeat,
  });
}

class ReminderIthItemUpdateClickedEvent extends ReminderEvent {
  final String title;
  final String time;
  final ToDo todoItem;
  final String dateTime;
  final String category;

  ReminderIthItemUpdateClickedEvent(
      {required this.title,
      required this.time,
      required this.todoItem,
      required this.category,
      required this.dateTime});
}

class ReminderIthItemCheckBoxClickedEvent extends ReminderEvent {
  final ToDo todoItem;
  final String category;

  ReminderIthItemCheckBoxClickedEvent(
      {required this.category, required this.todoItem});
}
