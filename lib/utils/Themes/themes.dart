import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../fonts/font_size.dart';

class Themes {
  //primaryColor = main App color

  //primaryColorLight == used for bottombar unselectedlabelcolor
  //primaryColorDark == selected tile color
  //canvas color == selected tile text color
  static getLightModeTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: AppColors.kblackColor),
      primaryColor: AppColors.kblue600,
      primaryColorLight:
          AppColors.kGreyColor, //used for bottombar unselectedlabelcolor
      primaryColorDark: AppColors.klightModeTileColor,
      canvasColor: AppColors.kwhiteColor,
      scaffoldBackgroundColor: AppColors.kscreenColor,
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kblue600,
          actionsIconTheme: const IconThemeData(color: AppColors.kwhiteColor),
          iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.kwhiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: AppColors.kblackColor,
            fontSize: FontSize.getTaskPlannerDescriptionFontSize(context)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.kblackColor)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.kblackColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.kblackColor)),
      ),
      listTileTheme: ListTileThemeData(
          tileColor: AppColors.kwhiteColor,
          titleTextStyle: FontSize.getToDoItemTileTextStyle(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textColor: AppColors.kblackColor,
          iconColor: AppColors.kblackColor),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kblue600),
      bottomSheetTheme: BottomSheetThemeData(
          dragHandleColor: AppColors.kGreyColor,
          showDragHandle: true,
          backgroundColor: AppColors.kscreenColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kscreenColor,
        selectedItemColor: AppColors.kblue600,
        unselectedItemColor: AppColors.kGreyColor,
        unselectedLabelStyle: FontSize.getBottomTextStyle(context),
        selectedLabelStyle: FontSize.getBottomSelectedStyle(context),
      ),
      colorScheme: const ColorScheme.light(
          primary: AppColors.kblue600,
          secondary: AppColors.kblue600,
          onSecondary: AppColors.kwhiteColor));

  static getDarkModeTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      canvasColor: AppColors.kblackColor,
      scaffoldBackgroundColor: AppColors.kGreycanvasColor,
      primaryColorLight: AppColors.kscreenColor, //used for buttons
      primaryColorDark: AppColors.kdarkModeTileColor,
      primaryColor: AppColors.kmediumBlueColor,
      iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kmediumBlueColor,
          iconTheme: const IconThemeData(color: AppColors.kblackColor),
          actionsIconTheme: const IconThemeData(color: AppColors.kwhiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              // color: AppColors.kblackColor,
              color: AppColors.kwhiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: AppColors.kwhiteColor,
            fontSize: FontSize.getTaskPlannerDescriptionFontSize(context)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.kwhiteColor)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.kwhiteColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.kwhiteColor)),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.kblackColor,
        titleTextStyle: FontSize.getToDoItemTileTextStyle(context),
        textColor: AppColors.kwhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        iconColor: AppColors.kwhiteColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kmediumBlueColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.kblackColor,
        selectedItemColor: AppColors.kmediumBlueColor,
        unselectedItemColor: AppColors.kscreenColor,
        unselectedLabelStyle: FontSize.getBottomTextStyle(context),
        selectedLabelStyle: FontSize.getBottomSelectedStyle(context),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: AppColors.kscreenColor,
          showDragHandle: true,
          backgroundColor: AppColors.kGreycanvasColor),
      colorScheme: ColorScheme.dark(
          surfaceTint: Theme.of(context).scaffoldBackgroundColor,
          primary: AppColors.kmediumBlueColor,
          secondary: AppColors.kmediumBlueColor,
          onSecondary: AppColors.kwhiteColor));
}
