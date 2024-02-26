import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/SQL/sql_helper.dart';
import 'package:task_planner/models/reminder_model.dart';
import 'package:task_planner/resources/algorithm/sort_algo.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/reminder_dropdown.dart';
import 'package:task_planner/resources/components/drop_down/repeat_drop_down.dart';
import 'package:task_planner/utils/dates/date_time.dart';

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
    List<List<ReminderModel>> reminderItems = await fetchFullToDoList();

    if (reminderItems.isEmpty) {
      emit(ReminderEmptyLoadedState());
    } else {
      List<bool> isVisible = getVisibleStatus(reminderItems);
      emit(ReminderLoadedSuccessState(
          isVisible: isVisible, reminderItems: reminderItems));
    }
  }

  FutureOr<void> reminderCategoryChangedEvent(
      ReminderCategoryChangedEvent event, Emitter<ReminderState> emit) async {
    List<List<ReminderModel>> reminderItems = [];
    reminderItems = await fetchByCategory(event.category);

    if (reminderItems.isEmpty) {
      emit(ReminderEmptyLoadedState());
    } else {
      List<bool> isVisible = getVisibleStatus(reminderItems);
      emit(ReminderLoadedSuccessState(
          isVisible: isVisible, reminderItems: reminderItems));
    }
  }

  FutureOr<void> reminderAddTaskClickedEvent(
      ReminderAddTaskClickedEvent event, Emitter<ReminderState> emit) async {
    ReminderModel reminderItem = ReminderModel(
      title: event.title,
      date: event.date,
      isCompleted: false,
      completionTime: event.completionTime,
      category: event.category,
      reminder: event.reminderTime,
      repeat: event.repeat,
    );
    await ReminderSQLHelper.createItem(reminderItem).then((value) {
      emit(ReminderCloseSheetActionState());
    }).onError((error, stackTrace) {
      emit(ReminderCloseSheetActionState());
    });
  }

  FutureOr<void> reminderDeleteItemPressedEvent(
      ReminderDeleteItemPressedEvent event, Emitter<ReminderState> emit) async {
    await ReminderSQLHelper.deleteItem(event.reminderItem).then((value) async {
      List<List<ReminderModel>> reminderItems = [];
      if (event.category == "All") {
        reminderItems = await fetchFullToDoList();
      } else {
        reminderItems = await fetchByCategory(event.category);
      }
      // List<List<ReminderModel>> reminders = [];
      // Map<String, List<ReminderModel>> dateMaps = {};
      // for (var element in reminderItems) {
      //   dateMaps[element.date]?.add(element);
      // }
      // dateMaps.forEach(
      //   (key, value) {
      //     reminders.add(value);
      //   },
      // );
      if (reminderItems.isEmpty) {
        emit(ReminderEmptyLoadedState());
      } else {
        List<bool> isVisible = getVisibleStatus(reminderItems);
        emit(ReminderLoadedSuccessState(
            isVisible: isVisible, reminderItems: reminderItems));
      }
    }).onError((error, stackTrace) {});
  }

  FutureOr<void> reminderIthItemUpdateClickedEvent(
      ReminderIthItemUpdateClickedEvent event,
      Emitter<ReminderState> emit) async {
    ReminderModel reminderItem = event.reminderItem;
    reminderItem.title = event.title;
    reminderItem.completionTime = event.time;
    reminderItem.date = event.dateTime;
    reminderItem.category = CategoryDropDownList.getCategoryDropDownVal();
    reminderItem.reminder = ReminderDropdown.getReminderVal();
    reminderItem.repeat = RepeatDropdown.getRepeatVal();
    await ReminderSQLHelper.updateItem(reminderItem).then((value) async {
      // List<ReminderModel> reminderItems = [];
      // if (event.category == "All") {
      //   reminderItems = await fetchFullToDoList();
      // } else {
      //   reminderItems = await fetchByCategory(event.category);
      // }
      emit(ReminderCloseSheetActionState());
    }).onError((error, stackTrace) {
      emit(ReminderCloseSheetActionState());
    });
  }

  FutureOr<void> reminderIthItemCheckBoxClickedEvent(
      ReminderIthItemCheckBoxClickedEvent event,
      Emitter<ReminderState> emit) async {
    event.reminderItem.isCompleted = !event.reminderItem.isCompleted!;
    List<List<ReminderModel>> reminderItems = [];
    await ReminderSQLHelper.updateCheckBoxItem(event.reminderItem)
        .then((value) async {
      if (event.category == "All") {
        reminderItems = await fetchFullToDoList();
      } else {
        reminderItems = await fetchByCategory(event.category);
      }
      // List<List<ReminderModel>> reminders = [];
      // Map<String, List<ReminderModel>> dateMaps = {};
      // for (var element in reminderItems) {
      //   dateMaps[element.date]?.add(element);
      // }
      // dateMaps.forEach(
      //   (key, value) {
      //     reminders.add(value);
      //   },
      // );

      List<bool> isVisible = getVisibleStatus(reminderItems);
      emit(ReminderLoadedSuccessState(
          isVisible: isVisible, reminderItems: reminderItems));
    }).onError((error, stackTrace) {});
  }

  Future<List<List<ReminderModel>>> fetchFullToDoList() async {
    List<ReminderModel> reminderItems = [];
    var response = await ReminderSQLHelper.getAllToDoItems();
    for (int i = 0; i < response.length; i++) {
      reminderItems.add(ReminderModel.fromJson(response[i]));
    }
    reminderItems =
        Sorting.sortGivenTodoListAccordtingToDateTime(reminderItems);

    List<List<ReminderModel>> reminders = [];
    Map<String, List<ReminderModel>> dateMaps = {};
    for (var element in reminderItems) {
      dateMaps[element.date!] = [];
    }
    for (var element in reminderItems) {
      dateMaps[element.date]?.add(element);
    }
    dateMaps.forEach(
      (key, value) {
        reminders.add(value);
      },
    );

    return reminders;
  }

  Future<List<List<ReminderModel>>> fetchByCategory(String category) async {
    List<ReminderModel> reminderItems = [];
    var response = await ReminderSQLHelper.getListByCategory(category);
    for (int i = 0; i < response.length; i++) {
      reminderItems.add(ReminderModel.fromJson(response[i]));
    }
    reminderItems =
        Sorting.sortGivenTodoListAccordtingToDateTime(reminderItems);
    List<List<ReminderModel>> reminders = [];
    Map<String, List<ReminderModel>> dateMaps = {};
    for (var element in reminderItems) {
      dateMaps[element.date!] = [];
    }
    for (var element in reminderItems) {
      dateMaps[element.date]?.add(element);
    }
    dateMaps.forEach(
      (key, value) {
        reminders.add(value);
      },
    );

    return reminders;
  }

  List<bool> getVisibleStatus(List<List<ReminderModel>> reminderItems) {
    List<bool> isVisible = List.filled(reminderItems.length, true);
    for (int i = 0; i < reminderItems.length; i++) {
      if (reminderItems[i].isNotEmpty) {
        if (Dates.today
                .toString()
                .substring(0, 10)
                .compareTo(reminderItems[i][0].date!) ==
            1) {
          isVisible[i] = false;
        }
      }
    }
    return isVisible;
  }
}
