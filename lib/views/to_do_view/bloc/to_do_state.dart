part of 'to_do_bloc.dart';

@immutable
sealed class ToDoState {}

abstract class ToDoActionState extends ToDoState {}

class ToDoCloseSheetActionState extends ToDoActionState {}

class ToDoShowErrorMsgActionState extends ToDoActionState {
  final String errorMsg;

  ToDoShowErrorMsgActionState({required this.errorMsg});
}

final class ToDoInitial extends ToDoState {}

class ToDoListLoadedSuccessState extends ToDoState {
  final List<ToDoModel> todoPendingItems;
  final List<ToDoModel> todoCompletedItems;

  ToDoListLoadedSuccessState(
    this.todoPendingItems,
    this.todoCompletedItems,
  );
}

class ToDoListLoadingState extends ToDoState {}

class ToDoListEmptyState extends ToDoState {}
