// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_planner/resources/button_demo.dart';
import 'package:task_planner/views/login_view/bloc/login_bloc.dart';

import '../../../database/auth/app_authentication.dart';
import '../../home_view/ui/home_view.dart';

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
    final AuthManager authManager = AuthManager();
    return Scaffold(
      appBar: AppBar(title: const Text("Task Planner")),
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listenWhen: (previous, current) => current is LoginActionState,
        listener: (context, state) {
          if (state is LoginNavigateToHomePageActionState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        },
        buildWhen: (previous, current) => current is! LoginActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoginLoadedSuccessState:
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("images/task.jpg"),
                    Center(
                      child: Buttons.getRectangleButton(context, () async {
                        await authManager.signInAnonymously().then((value) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        });
                      }, "Log-In Anonymously"),
                    )
                  ]);

            default:
              return Container();
          }
        },
      ),
    );
  }
}
