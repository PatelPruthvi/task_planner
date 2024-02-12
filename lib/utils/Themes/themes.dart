import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../fonts/font_size.dart';

class Themes {
  //primaryColor = main App color

  //primaryColorLight == used for bottombar unselectedlabelcolor
  //primaryColorDark == selected tile color
  // splash color == unselected tile color
  static getLightModeTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: AppColors.kblackColor),
      // canvasColor: ,
      listTileTheme: ListTileThemeData(
          tileColor: AppColors.kwhiteColor,
          titleTextStyle: FontSize.getToDoItemTileTextStyle(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textColor: AppColors.kblackColor,
          iconColor: AppColors.kblackColor),
      scaffoldBackgroundColor: AppColors.kscreenColor,
      primaryColorLight:
          AppColors.kGreyColor, //used for bottombar unselectedlabelcolor
      primaryColorDark: AppColors.klightModeTileColor,
      splashColor: AppColors.kwhiteColor,
      primaryColor: AppColors.kblue600,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kblue600),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kblue600,
          iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.kwhiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)),
      bottomSheetTheme: BottomSheetThemeData(
          dragHandleColor: AppColors.kGreyColor,
          showDragHandle: true,
          backgroundColor: AppColors.kscreenColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
      iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
      // canvasColor: ,
      scaffoldBackgroundColor: AppColors.kGreycanvasColor,
      primaryColorLight: AppColors.kscreenColor, //used for buttons
      primaryColorDark: AppColors.kwhiteColor,
      primaryColor: AppColors.kmediumBlueColor,
      splashColor: AppColors.kdarkModeTileColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kmediumBlueColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kmediumBlueColor,
          iconTheme: const IconThemeData(color: AppColors.kblackColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.kblackColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.kblackColor,
        titleTextStyle: FontSize.getToDoItemTileTextStyle(context),
        textColor: AppColors.kwhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        iconColor: AppColors.kwhiteColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.kmediumBlueColor,
        unselectedItemColor: AppColors.kscreenColor,
        unselectedLabelStyle: FontSize.getBottomTextStyle(context),
        selectedLabelStyle: FontSize.getBottomSelectedStyle(context),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: AppColors.kscreenColor,
          showDragHandle: true,
          backgroundColor: AppColors.kblackColor),
      colorScheme: ColorScheme.dark(
          surfaceTint: Theme.of(context).scaffoldBackgroundColor,
          primary: AppColors.kmediumBlueColor,
          secondary: AppColors.kmediumBlueColor,
          onSecondary: AppColors.kwhiteColor));
}
