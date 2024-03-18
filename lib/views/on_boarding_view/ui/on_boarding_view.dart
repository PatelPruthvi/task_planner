import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:task_planner/AppUrls/app_url.dart';
import 'package:task_planner/models/enum_models.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/utils/widgets/utils.dart';
import 'package:task_planner/views/login_view/bloc/login_bloc.dart';

import '../../bottom_bar_view/bottom_bar_view.dart';

class OnBoardingPage extends StatefulWidget {
  final LoginBloc loginBloc;
  const OnBoardingPage({super.key, required this.loginBloc});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int selectedIndex = 0; // default index
  int pageCount = 2; //default counts
  late final PageController _pageController;

  @override
  void initState() {
    widget.loginBloc.add(LoginOnBoardingInitialEvent());
    _pageController = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Connectivity connectivity = Connectivity();
    return StreamBuilder<ConnectivityResult>(
      stream: connectivity.onConnectivityChanged,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            final state = snapshot.data;
            switch (state) {
              case ConnectivityResult.none:
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.network_check,
                                  color: AppColors.kmaroonColor),
                              Text(
                                "No Internet",
                                textAlign: TextAlign.center,
                                style: FontDecors.getBottomSheetTitleStyle(
                                    context),
                              ),
                              const Icon(Icons.lte_mobiledata,
                                  color: AppColors.kmaroonColor),
                            ],
                          ),
                        ),
                        Lottie.asset(AppUrls.noInternetAnim),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "No connection, please check your internet connectivity. During initial setup, please ensure an internet connection for optimal functionality. After setup, the app operates seamlessly offline. Enjoy planning!",
                            textAlign: TextAlign.justify,
                            style: FontDecors.getToDoItemTileTextStyle(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              default:
                widget.loginBloc.add(LoginOnBoardingInitialEvent());
                return Scaffold(
                  body: BlocConsumer<LoginBloc, LoginState>(
                      bloc: widget.loginBloc,
                      listenWhen: (previous, current) =>
                          current is LoginActionState,
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
                      buildWhen: (previous, current) =>
                          current is! LoginActionState,
                      builder: (context, state) {
                        int i = 0;
                        switch (state.runtimeType) {
                          case LoginLoadingState:
                            return const Center(
                                child: CircularProgressIndicator());

                          case LoginLoadedSuccessState:
                            final successState =
                                state as LoginLoadedSuccessState;
                            pageCount = successState.imgUrls.length + 1;
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppBar(
                                    backgroundColor: Colors.transparent,
                                    toolbarHeight:
                                        Dimensions.getAppBarHeight(context) *
                                            1.5,
                                    title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppUrls.blackImagePath,
                                              width: Dimensions.getScreenWidth(
                                                      context) *
                                                  0.1,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Task Planner",
                                              style: Theme.of(context)
                                                  .appBarTheme
                                                  .titleTextStyle!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor),
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
                                                _pageController.animateToPage(
                                                    selectedIndex,
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeInOut);
                                              },
                                              child: Text("Skip",
                                                  style: Theme.of(context)
                                                      .appBarTheme
                                                      .titleTextStyle!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)))
                                          : Container()
                                    ],
                                  ),
                                  Expanded(
                                    child:
                                        Stack(fit: StackFit.expand, children: [
                                      PageView(
                                        controller: _pageController,
                                        onPageChanged: (value) {
                                          setState(() {
                                            selectedIndex = value;
                                          });
                                        },
                                        children: [
                                          for (i = 0;
                                              i < successState.imgUrls.length;
                                              i++)
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    height: Dimensions
                                                            .getScreenHeight(
                                                                context) *
                                                        0.05),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Text(
                                                    onboardingTitle[i],
                                                    style: FontDecors
                                                        .getOnBoardingPageTitleTextStyle(
                                                            context),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Image.network(
                                                      successState.imgUrls[i],
                                                      height:
                                                          Dimensions
                                                              .getScreenHeight(
                                                                  context),
                                                      width:
                                                          Dimensions.getScreenWidth(
                                                              context),
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Image.asset(
                                                          onboardingImagePaths[
                                                              selectedIndex],
                                                          fit: BoxFit.fill,
                                                          height: Dimensions
                                                              .getScreenHeight(
                                                                  context),
                                                          width: Dimensions
                                                              .getScreenWidth(
                                                                  context));
                                                    }
                                                  }, errorBuilder: (context,
                                                          error, stackTrace) {
                                                    return Image.asset(
                                                        onboardingImagePaths[
                                                            selectedIndex],
                                                        fit: BoxFit.fill,
                                                        height: Dimensions
                                                            .getScreenHeight(
                                                                context),
                                                        width: Dimensions
                                                            .getScreenWidth(
                                                                context));
                                                  }),
                                                ),
                                              ],
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(28.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Welcome to Task Planner!\n",
                                                          style: FontDecors
                                                                  .getBottomSheetTitleStyle(
                                                                      context)
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900)),
                                                      Text(
                                                          "Dive into productivity and organization. Let's start planning together!",
                                                          style: FontDecors
                                                              .getBottomSheetTitleStyle(
                                                                  context)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      40,
                                                      0,
                                                      40,
                                                      Dimensions
                                                              .getScreenHeight(
                                                                  context) *
                                                          0.09),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        widget.loginBloc.add(
                                                            LoginButtonPressedEvent());
                                                      },
                                                      style: ButtonStyle(
                                                          shape: MaterialStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12))),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Text(
                                                                "Continue",
                                                                style: FontDecors
                                                                    .getButtonTextStyle(
                                                                        context)),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: Dimensions.getScreenHeight(
                                                context) *
                                            0.05,
                                        left:
                                            Dimensions.getScreenWidth(context) *
                                                0.4,
                                        child: DotsIndicator(
                                          dotsCount: pageCount,
                                          position: selectedIndex,
                                          decorator: DotsDecorator(
                                              size: const Size.square(9.0),
                                              activeSize: const Size(27.0, 9.0),
                                              activeShape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))),
                                          onTap: (position) {
                                            setState(() {
                                              selectedIndex = position;
                                            });
                                            _pageController.animateToPage(
                                                selectedIndex,
                                                duration: const Duration(
                                                    milliseconds: 200),
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
                      }),
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
          default:
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.network_check,
                              color: AppColors.kmaroonColor),
                          Text(
                            "No Internet",
                            textAlign: TextAlign.center,
                            style: FontDecors.getBottomSheetTitleStyle(context),
                          ),
                          const Icon(Icons.lte_mobiledata,
                              color: AppColors.kmaroonColor),
                        ],
                      ),
                    ),
                    Lottie.asset(AppUrls.noInternetAnim),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "No connection, please check your internet connectivity. During initial setup, please ensure an internet connection for optimal functionality. After setup, the app operates seamlessly offline. Enjoy planning!",
                        textAlign: TextAlign.justify,
                        style: FontDecors.getToDoItemTileTextStyle(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
