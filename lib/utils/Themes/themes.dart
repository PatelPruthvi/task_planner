import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../fonts/font_size.dart';

class Themes {
  static getLightModeTheme(BuildContext context) => ThemeData(
      iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
      canvasColor: AppColors.kscreenColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kmainColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kmainColor,
          iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.kwhiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)));
  static getDarkModeTheme(BuildContext context) => ThemeData(
      iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
      canvasColor: AppColors.kscreenColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.kmainColor),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.kmainColor,
          iconTheme: const IconThemeData(color: AppColors.kwhiteColor),
          elevation: 0.0,
          titleSpacing: 1.3,
          titleTextStyle: TextStyle(
              color: AppColors.kwhiteColor,
              fontSize: FontSize.getAppBarTitleFontSize(context),
              fontWeight: FontWeight.w500)));
}
