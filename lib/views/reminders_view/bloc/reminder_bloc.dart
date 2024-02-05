import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/SQL/sql_helper.dart';
import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/resources/algorithm/sort_algo.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    on<ReminderInitialEvent>(reminderInitialEvent);
    on<ReminderCategoryChangedEvent>(reminderCategoryChangedEvent);
    on<ReminderAddTaskClickedEvent>(reminderAddTaskClickedEvent);
    on<ReminderDeleteItemPressedEvent>(reminderDeleteItemPressedEvent);
    on<ReminderIthItemUpdateClickedEvent>(reminderIthItemUpdateClickedEvent);
    on<ReminderIthItemCheckBoxClickedEvent>(
        reminderIthItemCheckBoxClickedEvent);
  }

  FutureOr<void> reminderInitialEvent(
      ReminderInitialEvent event, Emitter<ReminderState> emit) async {
    List<ToDo> todoItems = await fetchFullToDoList();

    if (todoItems.isEmpty) {
      emit(ReminderEmptyLoadedState());
    } else {
      emit(ReminderLoadedSuccessState(todoItems: todoItems));
    }
  }

  FutureOr<void> reminderCategoryChangedEvent(
      ReminderCategoryChangedEvent event, Emitter<ReminderState> emit) async {
    List<ToDo> todoItems = [];
    var response = await ToDoSQLhelper.getListByCategory(event.category);
    for (int i = 0; i < response.length; i++) {
      todoItems.add(ToDo.fromJson(response[i]));
    }
    todoItems = Sorting.sortGivenTodoListAccordtingToDateTime(todoItems);
    if (todoItems.isEmpty) {
      emit(ReminderEmptyLoadedState());
    } else {
      emit(ReminderLoadedSuccessState(todoItems: todoItems));
    }
  }

  FutureOr<void> reminderAddTaskClickedEvent(
      ReminderAddTaskClickedEvent event, Emitter<ReminderState> emit) async {}

  FutureOr<void> reminderDeleteItemPressedEvent(
      ReminderDeleteItemPressedEvent event, Emitter<ReminderState> emit) async {
    await ToDoSQLhelper.deleteItem(event.todoItem).then((value) async {
      List<ToDo> todoItems = await fetchFullToDoList();

      if (todoItems.isEmpty) {
        emit(ReminderEmptyLoadedState());
      } else {
        emit(ReminderLoadedSuccessState(todoItems: todoItems));
      }
    }).onError((error, stackTrace) {});
  }

  FutureOr<void> reminderIthItemUpdateClickedEvent(
      ReminderIthItemUpdateClickedEvent event,
      Emitter<ReminderState> emit) async {}

  FutureOr<void> reminderIthItemCheckBoxClickedEvent(
      ReminderIthItemCheckBoxClickedEvent event,
      Emitter<ReminderState> emit) async {
    event.todoItem.isCompleted = !event.todoItem.isCompleted!;
    await ToDoSQLhelper.updateCheckBoxItem(event.todoItem).then((value) async {
      List<ToDo> todoItems = await fetchFullToDoList();

      emit(ReminderLoadedSuccessState(todoItems: todoItems));
    }).onError((error, stackTrace) {});
  }

  Future<List<ToDo>> fetchFullToDoList() async {
    List<ToDo> todoItems = [];
    var response = await ToDoSQLhelper.getAllToDoItems();
    for (int i = 0; i < response.length; i++) {
      todoItems.add(ToDo.fromJson(response[i]));
    }
    todoItems = Sorting.sortGivenTodoListAccordtingToDateTime(todoItems);

    return todoItems;
  }
}
