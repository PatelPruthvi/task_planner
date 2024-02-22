// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/AppUrls/app_url.dart';

import 'package:task_planner/utils/widgets/utils.dart';
import 'package:task_planner/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:task_planner/views/login_view/bloc/login_bloc.dart';
import 'package:task_planner/views/on_boarding_view/ui/on_boarding_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginBloc loginBloc = LoginBloc();

  @override
  void initState() {
    loginBloc.add(LoginInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        buildWhen: (previous, current) => current is! LoginActionState,
        builder: (context, state) {
          return Image.asset(AppUrls.imageLogoPath);
        },
        listenWhen: (previous, current) => current is LoginActionState,
        listener: (context, state) {
          if (state is LoginNavigateToHomePageActionState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomBarView()));
          } else if (state is LoginShowErrorMsgActionState) {
            Utils.flushBarErrorMsg(state.error, context);
          } else if (state is LoginNavigateToOnBoardingPageActionState) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OnBoardingPage(loginBloc: loginBloc),
                ));
          }
        },
      ),
    );
  }
}
