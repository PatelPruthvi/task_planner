import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      primaryColor: AppColors.kmaroonColor,
      primaryColorLight:
          AppColors.kGreyColor, //used for bottombar unselectedlabelcolor
      primaryColorDark: AppColors.klightModeTileColor,
      canvasColor: AppColors.kwhiteColor,
      scaffoldBackgroundColor: AppColors.kscreenColor,
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kmaroonColor,
          actionsIconTheme: const IconThemeData(color: AppColors.kscreenColor),
          iconTheme: const IconThemeData(color: AppColors.kscreenColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.kscreenColor,
              fontSize: FontDecors.getAppBarTitleFontSize(context),
              fontFamily: GoogleFonts.comfortaa().fontFamily,
              fontWeight: FontWeight.bold)),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: AppColors.kblackColor,
            fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context)),
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
          titleTextStyle: FontDecors.getToDoItemTileTextStyle(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textColor: AppColors.kblackColor,
          iconColor: AppColors.kblackColor),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kmaroonColor),
      bottomSheetTheme: BottomSheetThemeData(
          dragHandleColor: AppColors.kGreyColor,
          showDragHandle: true,
          backgroundColor: AppColors.kscreenColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.shifting,
        backgroundColor: AppColors.kscreenColor,
        selectedItemColor: AppColors.kmaroonColor,
        unselectedItemColor: AppColors.kGreyColor,
        unselectedLabelStyle:
            FontDecors.getBottomNavBarUnSelectedTextStyle(context),
        selectedLabelStyle:
            FontDecors.getBottomNavBarSelectedTextStyle(context),
      ),
      colorScheme: const ColorScheme.light(
          primary: AppColors.kmaroonColor,
          secondary: AppColors.kmaroonColor,
          onSecondary: AppColors.kwhiteColor));

  static getDarkModeTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      canvasColor: AppColors.kblackColor,
      scaffoldBackgroundColor: AppColors.kGreycanvasColor,
      primaryColorLight: AppColors.kscreenColor, //used for buttons
      primaryColorDark: AppColors.kdarkModeTileColor,
      primaryColor: AppColors.kdarkModeMaroonColor,
      iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kdarkModeMaroonColor,
          iconTheme: const IconThemeData(color: AppColors.kblackColor),
          actionsIconTheme: const IconThemeData(color: AppColors.kscreenColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              // color: AppColors.kblackColor,
              color: AppColors.kscreenColor,
              fontSize: FontDecors.getAppBarTitleFontSize(context),
              fontFamily: GoogleFonts.comfortaa().fontFamily,
              fontWeight: FontWeight.bold)),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: AppColors.kwhiteColor,
            fontSize: FontDecors.getTaskPlannerDescriptionFontSize(context)),
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
        titleTextStyle: FontDecors.getToDoItemTileTextStyle(context),
        textColor: AppColors.kwhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        iconColor: AppColors.kwhiteColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kdarkModeMaroonColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.kblackColor,
        selectedItemColor: AppColors.kdarkModeMaroonColor,
        unselectedItemColor: AppColors.kscreenColor,
        unselectedLabelStyle:
            FontDecors.getBottomNavBarUnSelectedTextStyle(context),
        selectedLabelStyle:
            FontDecors.getBottomNavBarSelectedTextStyle(context),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: AppColors.kscreenColor,
          showDragHandle: true,
          backgroundColor: AppColors.kGreycanvasColor),
      colorScheme: ColorScheme.dark(
          surfaceTint: Theme.of(context).scaffoldBackgroundColor,
          primary: AppColors.kdarkModeMaroonColor,
          secondary: AppColors.kdarkModeMaroonColor,
          onSecondary: AppColors.kwhiteColor));
}
