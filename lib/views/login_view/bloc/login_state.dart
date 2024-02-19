// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginActionState extends LoginState {}

class LoginLoadedSuccessState extends LoginState {
  final List<String> imgUrls;

  LoginLoadedSuccessState({required this.imgUrls});
}

class LoginNavigateToHomePageActionState extends LoginActionState {}

class LoginShowErrorMsgActionState extends LoginActionState {
  final String error;
  LoginShowErrorMsgActionState({required this.error});
}

class LoginLoadingState extends LoginState {}

class LoginLoadingFailedState extends LoginState {}
