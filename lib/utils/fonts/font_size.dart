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
  static getDescFontStyle(BuildContext context) => TextStyle(
      fontSize: FontSize.getTaskPlannerDescriptionFontSize(context),
      color: Theme.of(context).listTileTheme.textColor);
  static TextStyle getTextFieldTitleStyle(BuildContext context) =>
      TextStyle(fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static getBottomSelectedStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static getBottomTextStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).primaryColorLight,
      fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static getButtonTextStyle(BuildContext context) => TextStyle(
      color: AppColors.kwhiteColor,
      fontSize: FontSize.getTaskPlannerDescriptionFontSize(context));
  static TextStyle getToDoItemTileTextStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).listTileTheme.textColor,
      fontWeight: FontWeight.w500,
      fontSize: FontSize.getMediumFontSize(context));
  static getBottomSheetButtonTextStyle(BuildContext context) => TextStyle(
      color: AppColors.kwhiteColor,
      fontWeight: FontWeight.w500,
      fontSize: FontSize.getMediumFontSize(context));
  static getMEdiumBlackFontstyle(BuildContext context) =>
      Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
          color: Theme.of(context).listTileTheme.textColor,
          fontWeight: FontWeight.w600,
          fontSize: FontSize.getAppBarTitleFontSize(context));
  static TextStyle getMediumWhiteFontStyle(BuildContext context) => TextStyle(
      fontSize: FontSize.getMediumFontSize(context),
      fontWeight: FontWeight.w500,
      color: Theme.of(context).appBarTheme.titleTextStyle!.color);
  static TextStyle getPrimayColoredTitletext(BuildContext context) =>
      Theme.of(context)
          .appBarTheme
          .titleTextStyle!
          .copyWith(color: Theme.of(context).primaryColor);
}
