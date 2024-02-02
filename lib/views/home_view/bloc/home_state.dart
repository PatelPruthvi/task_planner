part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeInitialState extends HomeState {}

class HomeDateChangedState extends HomeState {
  final DateTime focusedDate;

  HomeDateChangedState({required this.focusedDate});
}

class HomeToDoNoDataState extends HomeState {}
