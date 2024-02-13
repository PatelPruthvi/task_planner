import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/SQL/sql_helper.dart';
import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/resources/algorithm/sort_algo.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/reminder_dropdown.dart';
import 'package:task_planner/resources/components/drop_down/repeat_drop_down.dart';

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
    todoItems = await fetchByCategory(event.category);
    if (todoItems.isEmpty) {
      emit(ReminderEmptyLoadedState());
    } else {
      emit(ReminderLoadedSuccessState(todoItems: todoItems));
    }
  }

  FutureOr<void> reminderAddTaskClickedEvent(
      ReminderAddTaskClickedEvent event, Emitter<ReminderState> emit) async {
    ToDo todoItem = ToDo(
      title: event.title,
      date: event.date,
      isCompleted: false,
      completionTime: event.completionTime,
      category: event.category,
      reminder: event.reminderTime,
      repeat: event.repeat,
    );
    await ToDoSQLhelper.createItem(todoItem).then((value) {
      emit(ReminderCloseSheetActionState());
    }).onError((error, stackTrace) {
      emit(ReminderCloseSheetActionState());
    });
  }

  FutureOr<void> reminderDeleteItemPressedEvent(
      ReminderDeleteItemPressedEvent event, Emitter<ReminderState> emit) async {
    await ToDoSQLhelper.deleteItem(event.todoItem).then((value) async {
      List<ToDo> todoItems = [];
      if (event.category == "All") {
        todoItems = await fetchFullToDoList();
      } else {
        todoItems = await fetchByCategory(event.category);
      }

      if (todoItems.isEmpty) {
        emit(ReminderEmptyLoadedState());
      } else {
        emit(ReminderLoadedSuccessState(todoItems: todoItems));
      }
    }).onError((error, stackTrace) {});
  }

  FutureOr<void> reminderIthItemUpdateClickedEvent(
      ReminderIthItemUpdateClickedEvent event,
      Emitter<ReminderState> emit) async {
    ToDo toDoItem = event.todoItem;
    toDoItem.title = event.title;
    toDoItem.completionTime = event.time;
    toDoItem.date = event.dateTime;
    toDoItem.category = CategoryDropDownList.getCategoryDropDownVal();
    toDoItem.reminder = ReminderDropdown.getReminderVal();
    toDoItem.repeat = RepeatDropdown.getRepeatVal();
    await ToDoSQLhelper.updateItem(toDoItem).then((value) async {
      // List<ToDo> todoItems = [];
      // if (event.category == "All") {
      //   todoItems = await fetchFullToDoList();
      // } else {
      //   todoItems = await fetchByCategory(event.category);
      // }
      emit(ReminderCloseSheetActionState());
    }).onError((error, stackTrace) {
      emit(ReminderCloseSheetActionState());
    });
  }

  FutureOr<void> reminderIthItemCheckBoxClickedEvent(
      ReminderIthItemCheckBoxClickedEvent event,
      Emitter<ReminderState> emit) async {
    event.todoItem.isCompleted = !event.todoItem.isCompleted!;
    List<ToDo> todoItems = [];
    await ToDoSQLhelper.updateCheckBoxItem(event.todoItem).then((value) async {
      if (event.category == "All") {
        todoItems = await fetchFullToDoList();
      } else {
        todoItems = await fetchByCategory(event.category);
      }
      List<List<ToDo>> todo = [];
      Map<String, List<ToDo>> dateMaps = {};
      for (var element in todoItems) {
        dateMaps[element.date]?.add(element);
      }
      dateMaps.forEach(
        (key, value) {
          todo.add(value);
        },
      );
      todo.forEach(
        (element) {
          element.forEach((element) {
            print(element.date);
          });
        },
      );

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

  Future<List<ToDo>> fetchByCategory(String category) async {
    List<ToDo> todoItems = [];
    var response = await ToDoSQLhelper.getListByCategory(category);
    for (int i = 0; i < response.length; i++) {
      todoItems.add(ToDo.fromJson(response[i]));
    }
    todoItems = Sorting.sortGivenTodoListAccordtingToDateTime(todoItems);
    return todoItems;
  }
}
