import 'package:flutter/material.dart';
import 'package:task_planner/utils/colors/app_colors.dart';

import '../../../utils/fonts/font_size.dart';

int colorHexCode = AppHexVals.orange;

class ColorDropDownList extends StatefulWidget {
  final int hexCode;
  const ColorDropDownList({super.key, required this.hexCode});

  @override
  State<ColorDropDownList> createState() => _ColorDropDownListState();
  static int getColorCode() => colorHexCode;
}

class _ColorDropDownListState extends State<ColorDropDownList> {
  @override
  void initState() {
    colorHexCode = widget.hexCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      iconEnabledColor: Theme.of(context).listTileTheme.textColor,
      value: colorHexCode,
      items: appHexColorCodes.map((colorVal) {
        return DropdownMenuItem(
            value: colorVal,
            child: Container(
              width: 40,
              height: FontSize.getAppBarTitleFontSize(context),
              decoration: BoxDecoration(
                  color: Color(colorVal),
                  borderRadius: BorderRadius.circular(10)),
            ));
      }).toList(),
      onChanged: (value) {
        setState(
          () {
            colorHexCode = value!;
          },
        );
      },
    );
  }
}
