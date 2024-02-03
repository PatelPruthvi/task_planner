import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';
import '../utils/fonts/font_size.dart';

class Buttons {
  static ElevatedButton getRectangleButton(
          BuildContext context, Function() onTap, String labelText) =>
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll(AppColors.kmainColor),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
          onPressed: onTap,
          child: Text(labelText, style: FontSize.getButtonTextStyle(context)));
}
