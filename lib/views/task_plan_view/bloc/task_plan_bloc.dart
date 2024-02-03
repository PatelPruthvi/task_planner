import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/SQL/sql_helper.dart';
import 'package:task_planner/models/task_planner_model.dart';
import 'package:task_planner/resources/algorithm/sort_algo.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/color_drop_down.dart';
import '../../../resources/components/calendar/main_cal.dart';
part 'task_plan_event.dart';
part 'task_plan_state.dart';

class TaskPlanBloc extends Bloc<TaskPlanEvent, TaskPlanState> {
  TaskPlanBloc() : super(TaskPlanInitial()) {
    on<TaskPlanInitialEvent>(taskPlanInitialEvent);
    on<TaskPlanAddTaskClickedEvent>(taskPlanAddTaskClickedEvent);
    on<TaskPlanIthItemDeletedEvent>(taskPlanIthItemDeletedEvent);
    on<TaskPlanUpdateIthTaskEvent>(taskPlanUpdateIthTaskEvent);
  }

  FutureOr<void> taskPlanInitialEvent(
      TaskPlanInitialEvent event, Emitter<TaskPlanState> emit) async {
    List<TaskPlanner> taskList = await fetchTaskPlannerList();

    if (taskList.isEmpty) {
      emit(TaskPlanListEmptystate());
    } else {
      emit(TaskPlanListLoadedSuccessState(taskPlannerList: taskList));
    }
  }

  FutureOr<void> taskPlanAddTaskClickedEvent(
      TaskPlanAddTaskClickedEvent event, Emitter<TaskPlanState> emit) async {
    DateTime dateTime = HomeCal.getSelectedDateTime();
    // DateTime dateTime = CalendarView.getSelectedDateTime();
    String date = dateTime.toString().substring(0, 10);
    int hexColorCode = ColorDropDownList.getColorCode();
    String category = CategoryDropDownList.getCategoryDropDownVal();
    TaskPlanner taskItem = TaskPlanner(
        title: event.taskName,
        startTime: event.startTime,
        endTime: event.endtime,
        description: event.description,
        date: date,
        hexColorCode: hexColorCode.toString(),
        category: category);
    await TaskPlannerHelper.createItem(taskItem);
    emit(TaskPlanCloseBottomSheetState());
  }

  FutureOr<void> taskPlanIthItemDeletedEvent(
      TaskPlanIthItemDeletedEvent event, Emitter<TaskPlanState> emit) async {
    await TaskPlannerHelper.deleteItem(event.taskItem);
    List<TaskPlanner> taskList = await fetchTaskPlannerList();

    if (taskList.isEmpty) {
      emit(TaskPlanListEmptystate());
    } else {
      emit(TaskPlanListLoadedSuccessState(taskPlannerList: taskList));
    }
  }

  FutureOr<void> taskPlanUpdateIthTaskEvent(
      TaskPlanUpdateIthTaskEvent event, Emitter<TaskPlanState> emit) async {
    String category = CategoryDropDownList.getCategoryDropDownVal();
    int hexVal = ColorDropDownList.getColorCode();
    TaskPlanner taskItem = TaskPlanner(
        id: event.taskItem.id,
        title: event.taskName,
        startTime: event.startTime,
        endTime: event.endtime,
        description: event.description,
        date: event.taskItem.date,
        hexColorCode: hexVal.toString(),
        category: category);
    await TaskPlannerHelper.updateItem(taskItem);
    emit(TaskPlanCloseBottomSheetState());
  }

  Future<List<TaskPlanner>> fetchTaskPlannerList() async {
    List<TaskPlanner> taskPlansList = [];
    String date = HomeCal.getSelectedDateTime().toString().substring(0, 10);
    // String date =
    //     CalendarView.getSelectedDateTime().toString().substring(0, 10);
    var response = await TaskPlannerHelper.getListByDay(date);
    for (int i = 0; i < response.length; i++) {
      taskPlansList.add(TaskPlanner.fromJson(response[i]));
    }
    taskPlansList = Sorting.sortGivenTaskPlannerList(taskPlansList);

    return taskPlansList;
  }
}
