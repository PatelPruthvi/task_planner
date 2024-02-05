part of 'task_plan_bloc.dart';

@immutable
sealed class TaskPlanState {}

abstract class TaskPlanActionState extends TaskPlanState {}

class TaskPlanCloseBottomSheetState extends TaskPlanActionState {}

final class TaskPlanInitial extends TaskPlanState {}

class TaskPlanListEmptystate extends TaskPlanState {}

class TaskPlanListLoadedSuccessState extends TaskPlanState {
  final List<TaskPlanner> taskPlannerList;

  TaskPlanListLoadedSuccessState({required this.taskPlannerList});
}
