import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/resources/components/calendar/infinite_view_calendar.dart';
import '../../../database/SQL/sql_helper.dart';

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
    List<ToDoModel> reminderItems = await fetchToDoList();
    List<ToDoModel> todoPending = [];
    List<ToDoModel> toDoCompleted = [];
    for (var element in reminderItems) {
      if (element.isCompleted == true) {
        toDoCompleted.add(element);
      } else {
        todoPending.add(element);
      }
    }

    if (reminderItems.isEmpty) {
      emit(ToDoListEmptyState());
    } else {
      emit(ToDoListLoadedSuccessState(todoPending, toDoCompleted));
    }
  }

  FutureOr<void> toDoAddTaskClickedEvent(
      ToDoAddTaskClickedEvent event, Emitter<ToDoState> emit) async {
    DateTime dateTime = InfiniteCalendar.getSelectedDateTime();
    // DateTime dateTime = HomeCal.getSelectedDateTime();
    // DateTime dateTime = CalendarView.getSelectedDateTime();
    String date = dateTime.toString().substring(0, 10);
    ToDoModel todoItem =
        ToDoModel(title: event.title, date: date, isCompleted: false);

    await ToDoSQLHelper.createItem(todoItem).then((value) {
      emit(ToDoCloseSheetActionState());
    }).onError((error, stackTrace) {
      emit(ToDoCloseSheetActionState());
      emit(ToDoShowErrorMsgActionState(errorMsg: error.toString()));
    });
  }

  FutureOr<void> toDoIthItemCheckBoxClickedEvent(
      ToDoIthItemCheckBoxClickedEvent event, Emitter<ToDoState> emit) async {
    event.todoItem.isCompleted = !event.todoItem.isCompleted!;
    await ToDoSQLHelper.updateCheckBoxItem(event.todoItem).then((value) async {
      List<ToDoModel> reminderItems = await fetchToDoList();
      List<ToDoModel> todoPending = [];
      List<ToDoModel> toDoCompleted = [];
      for (var element in reminderItems) {
        if (element.isCompleted == true) {
          toDoCompleted.add(element);
        } else {
          todoPending.add(element);
        }
      }
      emit(ToDoListLoadedSuccessState(todoPending, toDoCompleted));
    }).onError((error, stackTrace) {});

    List<ToDoModel> reminderItems = await fetchToDoList();
    List<ToDoModel> todoPending = [];
    List<ToDoModel> toDoCompleted = [];
    for (var element in reminderItems) {
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
    await ToDoSQLHelper.deleteItem(event.todoItem).then((value) async {
      List<ToDoModel> reminderItems = await fetchToDoList();
      List<ToDoModel> todoPending = [];
      List<ToDoModel> toDoCompleted = [];
      for (var element in reminderItems) {
        if (element.isCompleted == true) {
          toDoCompleted.add(element);
        } else {
          todoPending.add(element);
        }
      }

      if (reminderItems.isEmpty) {
        emit(ToDoListEmptyState());
      } else {
        emit(ToDoListLoadedSuccessState(todoPending, toDoCompleted));
      }
    }).onError((error, stackTrace) {});
  }

  FutureOr<void> toDoIthItemUpdateClickedEvent(
      ToDoIthItemUpdateClickedEvent event, Emitter<ToDoState> emit) async {
    ToDoModel todoItem = ToDoModel(
      id: event.todoItem.id,
      title: event.title,
      date: event.todoItem.date,
      isCompleted: event.todoItem.isCompleted,
    );
    if (todoItem != event.todoItem) {
      await ToDoSQLHelper.updateItem(todoItem).onError((error, stackTrace) {});

      emit(ToDoCloseSheetActionState());
    }
  }

  Future<List<ToDoModel>> fetchToDoList() async {
    List<ToDoModel> reminderItems = [];
    String date =
        InfiniteCalendar.getSelectedDateTime().toString().substring(0, 10);
    var response = await ToDoSQLHelper.getListByDay(date);
    for (int i = 0; i < response.length; i++) {
      reminderItems.add(ToDoModel.fromJson(response[i]));
    }

    return reminderItems;
  }
}
