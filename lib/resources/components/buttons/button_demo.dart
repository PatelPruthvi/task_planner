import 'package:flutter/material.dart';
import '../../../utils/fonts/font_size.dart';

class Buttons {
  static ElevatedButton getRectangleButton(
          BuildContext context, Function() onTap, String labelText) =>
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
          onPressed: onTap,
          child: Text(labelText, style: FontSize.getButtonTextStyle(context)));
}
