import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/resources/algorithm/sort_algo.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/main_cal.dart';

import '../../../database/SQL/sql_helper.dart';
import '../../../resources/components/calendar/calendar_montly.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  ToDoBloc() : super(ToDoInitial()) {
    on<ToDoInitialEvent>(toDoInitialEvent);
    on<ToDoAddTaskClickedEvent>(toDoAddTaskClickedEvent);
    on<ToDoIthItemCheckBoxClickedEvent>(toDoIthItemCheckBoxClickedEvent);
    on<ToDoIthItemDeletedButtonClickedEvent>(
        toDoIthItemDeletedButtonClickedEvent);
    on<ToDoIthItemUpdateClickedEvent>(toDoIthItemUpdateClickedEvent);
  }

  FutureOr<void> toDoInitialEvent(
      ToDoInitialEvent event, Emitter<ToDoState> emit) async {
    List<ToDo> todoItems = await fetchToDoList();
    List<ToDo> todoPending = [];
    List<ToDo> toDoCompleted = [];
    for (var element in todoItems) {
      if (element.isCompleted == true) {
        toDoCompleted.add(element);
      } else {
        todoPending.add(element);
      }
    }

    if (todoItems.isEmpty) {
      emit(ToDoListEmptyState());
    } else {
      emit(ToDoListLoadedSuccessState(todoPending, toDoCompleted));
    }
  }

  FutureOr<void> toDoAddTaskClickedEvent(
      ToDoAddTaskClickedEvent event, Emitter<ToDoState> emit) async {
    DateTime dateTime = HomeCal.getSelectedDateTime();
    String date = dateTime.toString().substring(0, 10);
    ToDo todoItem = ToDo(
        title: event.title,
        date: date,
        isCompleted: false,
        completionTime: event.completionTime,
        category: event.category);
    await ToDoSQLhelper.createItem(todoItem);
    emit(ToDoCloseSheetActionState());
  }

  FutureOr<void> toDoIthItemCheckBoxClickedEvent(
      ToDoIthItemCheckBoxClickedEvent event, Emitter<ToDoState> emit) async {
    event.todoItem.isCompleted = !event.todoItem.isCompleted!;
    await ToDoSQLhelper.updateItem(event.todoItem);
    List<ToDo> todoItems = await fetchToDoList();
    List<ToDo> todoPending = [];
    List<ToDo> toDoCompleted = [];
    for (var element in todoItems) {
      if (element.isCompleted == true) {
        toDoCompleted.add(element);
      } else {
        todoPending.add(element);
      }
    }
    emit(ToDoListLoadedSuccessState(todoPending, toDoCompleted));
  }

  FutureOr<void> toDoIthItemDeletedButtonClickedEvent(
      ToDoIthItemDeletedButtonClickedEvent event,
      Emitter<ToDoState> emit) async {
    await ToDoSQLhelper.deleteItem(event.todoItem);
    List<ToDo> todoItems = await fetchToDoList();
    List<ToDo> todoPending = [];
    List<ToDo> toDoCompleted = [];
    for (var element in todoItems) {
      if (element.isCompleted == true) {
        toDoCompleted.add(element);
      } else {
        todoPending.add(element);
      }
    }

    if (todoItems.isEmpty) {
      emit(ToDoListEmptyState());
    } else {
      emit(ToDoListLoadedSuccessState(todoPending, toDoCompleted));
    }
  }

  FutureOr<void> toDoIthItemUpdateClickedEvent(
      ToDoIthItemUpdateClickedEvent event, Emitter<ToDoState> emit) async {
    ToDo todoItem = ToDo(
        id: event.todoItem.id,
        title: event.title,
        date: event.todoItem.date,
        isCompleted: event.todoItem.isCompleted,
        completionTime: event.time,
        category: CategoryDropDownList.getCategoryDropDownVal());

    await ToDoSQLhelper.updateItem(todoItem);
    emit(ToDoCloseSheetActionState());
  }

  Future<List<ToDo>> fetchToDoList() async {
    List<ToDo> todoItems = [];
    // String date = HomeCal.getSelectedDateTime().toString().substring(0, 10);
    String date =
        CalendarView.getSelectedDateTime().toString().substring(0, 10);
    var response = await ToDoSQLhelper.getListByDay(date);
    for (int i = 0; i < response.length; i++) {
      todoItems.add(ToDo.fromJson(response[i]));
    }
    todoItems = Sorting.sortGivenTodoList(todoItems);
    return todoItems;
  }
}
