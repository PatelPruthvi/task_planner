part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginActionState extends LoginState {}

class LoginLoadedSuccessState extends LoginState {}

class LoginNavigateToHomePageActionState extends LoginActionState {}
