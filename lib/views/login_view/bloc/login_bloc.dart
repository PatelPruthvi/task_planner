import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_planner/database/auth/app_authentication.dart';
import 'package:task_planner/database/firebase/firebase_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonPressedEvent>(loginButtonPressedEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    final AuthManager authManager = AuthManager();
    bool val = await authManager.checkAuthState();
    if (val) {
      emit(LoginNavigateToHomePageActionState());
    } else {
      await FirebaseHelper.getFirebaseImageLinkAsList().then((value) {
        if (value.isNotEmpty) {
          emit(LoginLoadedSuccessState(imgUrls: value));
        } else {
          emit(LoginLoadingFailedState());
        }
      }).onError((error, stackTrace) {
        emit(LoginLoadingFailedState());
      });
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
    await FirebaseHelper.getFirebaseImageLinkAsList().then((value) {
      if (value.isNotEmpty) {
        emit(LoginLoadedSuccessState(imgUrls: value));
      } else {
        emit(LoginLoadingFailedState());
      }
    }).onError((error, stackTrace) {
      emit(LoginLoadingFailedState());
    });
  }
}
