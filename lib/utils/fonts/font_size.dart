import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';

class FontDecors {
  //----------------------------- FONT SIZES ------------------------
  static double getAppBarTitleFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.027;
  static double getTaskPlannerDescriptionFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.015;
  static double getMediumFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.023;
  static double getSmallMediumFontSize(BuildContext context) =>
      Dimensions.getScreenHeight(context) * 0.02;
//----------------------------- FONT STYLES ---------------------------

  //used in task planner's and reminder's description
  static TextStyle getDescFontStyle(BuildContext context) => TextStyle(
      fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context),
      fontFamily: GoogleFonts.raleway().fontFamily,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: Theme.of(context).listTileTheme.textColor);
  //used in task planner's title
  static TextStyle getPlannerTitleFontStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.raleway().fontFamily,
      letterSpacing: 1.2,
      color: Theme.of(context).listTileTheme.textColor,
      fontSize: FontDecors.getAppBarTitleFontSize(context));
  //used in bottom sheets textfield label and entered text styles, along with reminders, repeat and category..
  static TextStyle getTextFieldTitleStyle(BuildContext context) => TextStyle(
      fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context),
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.raleway().fontFamily,
      letterSpacing: 1.2);
  // used in dropdown widget's children text example (None, Annualy,...)
  static TextStyle getDropdownTextStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).listTileTheme.textColor,
      fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context),
      fontWeight: FontWeight.w200,
      fontFamily: GoogleFonts.raleway().fontFamily,
      letterSpacing: 1.2);
  //used in selected bottom bar label style
  static TextStyle getBottomNavBarSelectedTextStyle(BuildContext context) =>
      TextStyle(
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w900,
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context));
  //used in unselected bottom bar label style
  static TextStyle getBottomNavBarUnSelectedTextStyle(BuildContext context) =>
      TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontFamily: GoogleFonts.raleway().fontFamily,
          fontWeight: FontWeight.w100,
          letterSpacing: 1.2,
          fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context));
  //used in button's label text
  static TextStyle getButtonTextStyle(BuildContext context) => TextStyle(
      color: AppColors.kwhiteColor,
      fontFamily: GoogleFonts.comfortaa().fontFamily,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w700,
      fontSize: FontDecors.getMediumFontSize(context));
  // used in to-do item tile's title
  static TextStyle getToDoItemTileTextStyle(BuildContext context) => TextStyle(
      color: Theme.of(context).listTileTheme.textColor,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.raleway().fontFamily,
      letterSpacing: 1.2,
      fontSize: FontDecors.getMediumFontSize(context));
  // used in reminder item tile's title
  static TextStyle getReminderItemTitleTextStyle(BuildContext context) =>
      TextStyle(
          color: Theme.of(context).listTileTheme.textColor,
          fontWeight: FontWeight.w900,
          fontFamily: GoogleFonts.raleway().fontFamily,
          letterSpacing: 1.2,
          fontSize: FontDecors.getSmallMediumFontSize(context));
  //used in bottom sheet's title & no internet page's title
  static TextStyle getBottomSheetTitleStyle(BuildContext context) =>
      Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
          color: Theme.of(context).listTileTheme.textColor,
          fontWeight: FontWeight.w600,
          fontSize: FontDecors.getAppBarTitleFontSize(context));
  //used in infinite view calendar's header builder (ex. Feb 22, 2024 & Feb, 22)
  static TextStyle getMediumWhiteFontStyle(BuildContext context) => TextStyle(
      fontSize: FontDecors.getMediumFontSize(context),
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.raleway().fontFamily,
      color: Theme.of(context).appBarTheme.titleTextStyle!.color);
}
