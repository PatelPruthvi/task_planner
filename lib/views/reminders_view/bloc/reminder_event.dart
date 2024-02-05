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

  ReminderDeleteItemPressedEvent({required this.todoItem});
}

class ReminderAddTaskClickedEvent extends ReminderEvent {
  final String title;
  final String category;
  final String completionTime;
  final String reminderTime;
  final String date;

  ReminderAddTaskClickedEvent(
      {required this.title,
      required this.category,
      required this.completionTime,
      required this.reminderTime,
      required this.date});
}

class ReminderIthItemUpdateClickedEvent extends ReminderEvent {
  final String title;
  final String time;
  final ToDo todoItem;

  ReminderIthItemUpdateClickedEvent(
      {required this.title, required this.time, required this.todoItem});
}

class ReminderIthItemCheckBoxClickedEvent extends ReminderEvent {
  final ToDo todoItem;

  ReminderIthItemCheckBoxClickedEvent({required this.todoItem});
}
