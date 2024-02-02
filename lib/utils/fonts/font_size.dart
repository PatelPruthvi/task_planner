import 'package:flutter/material.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';

class FontSize {
  static double getAppBarTitleFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.027;
  static double getTaskPlannerDescriptionFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.017;
  static double getMediumFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.023;
  static getDescFontStyle(BuildContext context) =>
      TextStyle(fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static getTextFieldTitleStyle(BuildContext context) => TextStyle(
      color: AppColors.mainColor,
      fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static getButtonTextStyle(BuildContext context) => TextStyle(
      color: AppColors.whiteColor,
      fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static getToDoItemTileTextStyle(BuildContext context) => TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
      fontSize: FontSize.getMediumFontSize(context));
  static getMEdiumBlackFontstyle(BuildContext context) =>
      Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: FontSize.getAppBarTitleFontSize(context));
  static getMediumWhiteFontStyle(BuildContext context) => TextStyle(
      fontSize: FontSize.getMediumFontSize(context),
      color: AppColors.whiteColor);
}
