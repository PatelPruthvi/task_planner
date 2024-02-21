part of 'reminder_bloc.dart';

@immutable
sealed class ReminderState {}

final class ReminderInitial extends ReminderState {}

class ReminderLoadedSuccessState extends ReminderState {
  final List<List<ReminderModel>> reminderItems;

  ReminderLoadedSuccessState({required this.reminderItems});
}

class ReminderEmptyLoadedState extends ReminderState {}

abstract class ReminderActionState extends ReminderState {}

class ReminderCloseSheetActionState extends ReminderActionState {}

class ReminderShowErrorMsgActionState extends ReminderActionState {
  final String errorMsg;

  ReminderShowErrorMsgActionState({required this.errorMsg});
}
