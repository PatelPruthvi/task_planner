// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'to_do_bloc.dart';

@immutable
sealed class ToDoEvent {}

class ToDoInitialEvent extends ToDoEvent {}

class ToDoAddTaskClickedEvent extends ToDoEvent {
  final String title;
  final String category;
  final String completionTime;

  ToDoAddTaskClickedEvent(this.title, this.category, this.completionTime);
}

class ToDoIthItemUpdateClickedEvent extends ToDoEvent {
  final String title;
  final String time;
  final ToDo todoItem;

  ToDoIthItemUpdateClickedEvent({
    required this.title,
    required this.time,
    required this.todoItem,
  });
}

class ToDoIthItemCheckBoxClickedEvent extends ToDoEvent {
  final ToDo todoItem;

  ToDoIthItemCheckBoxClickedEvent({required this.todoItem});
}

class ToDoIthItemDeletedButtonClickedEvent extends ToDoEvent {
  final ToDo todoItem;

  ToDoIthItemDeletedButtonClickedEvent({required this.todoItem});
}
