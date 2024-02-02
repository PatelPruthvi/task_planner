import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/auth/app_authentication.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
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
}
