// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'to_do_bloc.dart';

@immutable
sealed class ToDoEvent {}

class ToDoInitialEvent extends ToDoEvent {}

class ToDoAddTaskClickedEvent extends ToDoEvent {
  final String title;

  ToDoAddTaskClickedEvent(this.title);
}

class ToDoIthItemUpdateClickedEvent extends ToDoEvent {
  final String title;

  final ToDoModel todoItem;

  ToDoIthItemUpdateClickedEvent({required this.title, required this.todoItem});
}

class ToDoIthItemCheckBoxClickedEvent extends ToDoEvent {
  final ToDoModel todoItem;

  ToDoIthItemCheckBoxClickedEvent({required this.todoItem});
}

class ToDoIthItemDeletedButtonClickedEvent extends ToDoEvent {
  final ToDoModel todoItem;

  ToDoIthItemDeletedButtonClickedEvent({required this.todoItem});
}
