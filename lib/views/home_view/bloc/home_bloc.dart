import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/utils/dates/date_time.dart';

part 'home_event.dart';
part 'home_state.dart';

final DateTime now = Dates.today;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeCalendarDateTappedEvent>(homeCalendarDateTappedEvent);
  }

  FutureOr<void> homeCalendarDateTappedEvent(
      HomeCalendarDateTappedEvent event, Emitter<HomeState> emit) async {
    emit(HomeDateChangedState(focusedDate: event.selectedDate));
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) {
    emit(HomeDateChangedState(focusedDate: now));
  }
}
