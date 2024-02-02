part of 'to_do_bloc.dart';

@immutable
sealed class ToDoState {}

abstract class ToDoActionState extends ToDoState {}

class ToDoCloseSheetActionState extends ToDoActionState {}

final class ToDoInitial extends ToDoState {}

class ToDoListLoadedSuccessState extends ToDoState {
  final List<ToDo> todoPendingItems;
  final List<ToDo> todoCompletedItems;

  ToDoListLoadedSuccessState(
    this.todoPendingItems,
    this.todoCompletedItems,
  );
}

class ToDoListLoadingState extends ToDoState {}

class ToDoListEmptyState extends ToDoState {}
