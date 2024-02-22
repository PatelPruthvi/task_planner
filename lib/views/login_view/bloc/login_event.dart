part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {}

class LoginOnBoardingInitialEvent extends LoginEvent {}

class LoginInternetNotConnectedEvent extends LoginEvent {}
