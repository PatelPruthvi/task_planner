// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int selectedIndex = 0; // default index
  final LoginBloc loginBloc = LoginBloc();
  int pageCount = 2; //default counts
  late final PageController _pageController;

  @override
  void initState() {
    loginBloc.add(LoginInitialEvent());
    _pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listenWhen: (previous, current) => current is LoginActionState,
        listener: (context, state) {
          if (state is LoginNavigateToHomePageActionState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomBarView()));
          } else if (state is LoginShowErrorMsgActionState) {
            Utils.flushBarErrorMsg(state.error, context);
          }
        },
        buildWhen: (previous, current) => current is! LoginActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoginLoadingState:
              return const Center(child: CircularProgressIndicator());
            case LoginLoadingFailedState:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "Internet connection required for Task Planner setup. Please connect and restart the app. If the issue persists, contact us for assistance.",
                  style: FontSize.getMEdiumBlackFontstyle(context),
                )),
              );
            case LoginLoadedSuccessState:
              final successState = state as LoginLoadedSuccessState;
              pageCount = successState.imgUrls.length + 1;
              return Column(mainAxisSize: MainAxisSize.min, children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  toolbarHeight: Dimensions.getAppBarHeight(context),
                  title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Image.asset(
                            AppUrls.blackImagePath,
                            width: Dimensions.getScreenWidth(context) * 0.1,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Task Planner",
                            style: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          )
                        ],
                      )),
                  actions: [
                    selectedIndex < pageCount - 1
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = pageCount - 1;
                              });
                              _pageController.animateToPage(selectedIndex,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            },
                            child: Text("Skip",
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor)))
                        : Container()
                  ],
                ),
                Expanded(
                  child: Stack(fit: StackFit.expand, children: [
                    PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      children: [
                        for (int i = 0; i < successState.imgUrls.length; i++)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Image.network(successState.imgUrls[i],
                                    height: Dimensions.getScreenHeight(context),
                                    width:
                                        Dimensions.getScreenWidth(context) - 10,
                                    fit: BoxFit.fill, loadingBuilder:
                                        (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }, errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppUrls.image1stBoardingPage,
                                    height:
                                        Dimensions.getTabBarViewHeight(context),
                                    width: Dimensions.getScreenWidth(context),
                                  );
                                }),
                              ),
                            ],
                          ),
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(
                              height:
                                  Dimensions.getScreenHeight(context) * 0.65,
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8.0),
                                  child: Text(
                                    "Welcome to Task Planner! Dive into productivity and organization. Let's start planning together. Welcome aboard!",
                                    // textAlign: TextAlign.justify,
                                    style: FontSize.getPrimayColoredTitletext(
                                        context),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                            child: ElevatedButton(
                                onPressed: () {
                                  loginBloc.add(LoginButtonPressedEvent());
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).primaryColor)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Continue",
                                        style: FontSize.getButtonTextStyle(
                                            context)),
                                  ],
                                )),
                          )
                        ])
                      ],
                    ),
                    Positioned(
                      bottom: Dimensions.getScreenHeight(context) * 0.05,
                      left: Dimensions.getScreenWidth(context) * 0.4,
                      child: DotsIndicator(
                        dotsCount: pageCount,
                        position: selectedIndex,
                        decorator: DotsDecorator(
                            size: const Size.square(9.0),
                            activeSize: const Size(27.0, 9.0),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        onTap: (position) {
                          setState(() {
                            selectedIndex = position;
                          });
                          _pageController.animateToPage(selectedIndex,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                      ),
                    )
                  ]),
                ),
              ]);
            default:
              return Container();
          }
        },
      ),
      floatingActionButton: selectedIndex < pageCount - 1
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  selectedIndex++;
                });
                _pageController.animateToPage(selectedIndex,
                    duration: const Duration(microseconds: 200),
                    curve: Curves.easeInOut);
              })
          : null,
    );
  }
}
