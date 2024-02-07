import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/auth/app_authentication.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonPressedEvent>(loginButtonPressedEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    final AuthManager authManager = AuthManager();
    bool val = await authManager.checkAuthState();
    if (val) {
      emit(LoginNavigateToHomePageActionState());
    } else {
      emit(LoginLoadedSuccessState());
    }
  }

  FutureOr<void> loginButtonPressedEvent(
      LoginButtonPressedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    await AuthManager().signInAnonymously().onError((error, stackTrace) {
      emit(LoginShowErrorMsgActionState(error: error.toString()));
      return null;
    });

    emit(LoginNavigateToHomePageActionState());
    emit(LoginLoadedSuccessState());
  }
}
