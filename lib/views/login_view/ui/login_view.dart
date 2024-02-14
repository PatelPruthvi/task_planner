// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:task_planner/AppUrls/app_url.dart';

import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/utils/widgets/utils.dart';
import 'package:task_planner/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:task_planner/views/login_view/bloc/login_bloc.dart';

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
        appBar: AppBar(
            title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Utils.getAppLogoForAppBar(context),
              Dimensions.getSmallerSizedBox(context),
              const Text("Task Planner")
            ],
          ),
        )),
        body: BlocConsumer<LoginBloc, LoginState>(
          bloc: loginBloc,
          listenWhen: (previous, current) => current is LoginActionState,
          listener: (context, state) {
            if (state is LoginNavigateToHomePageActionState) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomBarView()));
            } else if (state is LoginShowErrorMsgActionState) {
              Utils.flushBarErrorMsg(state.error, context);
            }
          },
          buildWhen: (previous, current) => current is! LoginActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case LoginLoadingState:
                return const Center(child: CircularProgressIndicator());
              case LoginLoadedSuccessState:
                return OnBoardingSlider(
                    totalPage: 5,
                    headerBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    controllerColor: Theme.of(context).primaryColor,
                    skipTextButton: Text("Skip",
                        style: FontSize.getToDoItemTileTextStyle(context)),
                    finishButtonText: "Continue",
                    onFinish: () {
                      loginBloc.add(LoginButtonPressedEvent());
                    },
                    background: [
                      Align(
                        child: Image.asset(AppUrls.image1stBoardingPage,
                            alignment: Alignment.center,
                            height: Dimensions.getTabBarViewHeight(context),
                            width: Dimensions.getScreenWidth(context)),
                      ),
                      Image.asset(AppUrls.image2ndBoardingPage,
                          height: Dimensions.getTabBarViewHeight(context),
                          width: Dimensions.getScreenWidth(context)),
                      Image.asset(AppUrls.image3rdBoardingPage,
                          height: Dimensions.getTabBarViewHeight(context),
                          width: Dimensions.getScreenWidth(context)),
                      Image.asset(AppUrls.image4thBoardingPage,
                          height: Dimensions.getTabBarViewHeight(context),
                          width: Dimensions.getScreenWidth(context)),
                      Image.asset(AppUrls.image5thBoardingPage,
                          height: Dimensions.getTabBarViewHeight(context),
                          width: Dimensions.getScreenWidth(context))
                    ],
                    speed: 2.0,
                    pageBodies: const [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Description 1")),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Description 2")),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Description 3")),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Description 4")),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Description 5"))
                    ]);
              default:
                return Container();
            }
          },
        ));
  }
}
