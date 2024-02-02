// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_plan_bloc.dart';

@immutable
sealed class TaskPlanEvent {}

class TaskPlanInitialEvent extends TaskPlanEvent {}

class TaskPlanAddTaskClickedEvent extends TaskPlanEvent {
  final String taskName;
  final String startTime;
  final String endtime;
  final String description;
  TaskPlanAddTaskClickedEvent({
    required this.taskName,
    required this.startTime,
    required this.endtime,
    required this.description,
  });
}

class TaskPlanUpdateIthTaskEvent extends TaskPlanEvent {
  final TaskPlanner taskItem;
  final String taskName;
  final String startTime;
  final String endtime;
  final String description;
  TaskPlanUpdateIthTaskEvent({
    required this.taskItem,
    required this.taskName,
    required this.startTime,
    required this.endtime,
    required this.description,
  });
}

class TaskPlanIthItemDeletedEvent extends TaskPlanEvent {
  final TaskPlanner taskItem;

  TaskPlanIthItemDeletedEvent({required this.taskItem});
}
