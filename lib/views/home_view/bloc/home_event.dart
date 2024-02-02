part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeCalendarDateTappedEvent extends HomeEvent {
  final DateTime selectedDate;

  HomeCalendarDateTappedEvent({required this.selectedDate});
}

class HomeAddTaskToDoClickedEvent extends HomeEvent {}

class HomeAddTaskPlanClickedEvent extends HomeEvent {}
