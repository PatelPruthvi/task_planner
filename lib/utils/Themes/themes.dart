import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../fonts/font_size.dart';

class Themes {
  static getLightModeTheme(BuildContext context) => ThemeData(
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      canvasColor: AppColors.screenColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.mainColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.mainColor,
          iconTheme: const IconThemeData(color: AppColors.whiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)));
  static getDarkModeTheme(BuildContext context) => ThemeData(
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      canvasColor: AppColors.screenColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.mainColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.mainColor,
          iconTheme: const IconThemeData(color: AppColors.whiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.whiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)));
}
