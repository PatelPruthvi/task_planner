import 'package:flutter/material.dart';

class Dimensions {
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double getAspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.aspectRatio;
  static double getCalendarDayHeight(BuildContext context) =>
      MediaQuery.of(context).size.height / 10;
  static double getCategoryButtonsHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.06;
  static double getCalendarDayWidth(BuildContext context) =>
      MediaQuery.of(context).size.width / 7;
  static double getTodoListViewHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.7;
  static double getTabBarViewHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.65;
  static double getSafeAreaHeight(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.05;
  static double getAppBarHeight(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.05;
  static double getTaskPlannerTileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.85;
  static double getToDoBottomSheetHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.35;
  static double getPlannerBottomSheetHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.7;
  static double getSliderWidth(BuildContext context) =>
      MediaQuery.of(context).size.width / 5;

  static SizedBox getSmallerSizedBox(BuildContext context) =>
      SizedBox(width: MediaQuery.of(context).size.width / 20);
}
