import 'package:flutter/material.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';

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
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: DropdownButton(
        iconSize: 0,
        value: colorHexCode,
        underline: const Text(""),
        borderRadius: BorderRadius.circular(15),
        items: appHexColorCodes.map((colorVal) {
          return DropdownMenuItem(
              value: colorVal,
              child: Container(
                width: Dimensions.getSmallerSizedBox(context).width! * 1.5,
                height: Dimensions.getSmallerSizedBox(context).width! * 1.5,
                decoration: BoxDecoration(
                    color: Color(colorVal),
                    borderRadius: BorderRadius.circular(
                        Dimensions.getSmallerSizedBox(context).width! * 1.5)),
              ));
        }).toList(),
        onChanged: (value) {
          setState(
            () {
              colorHexCode = value!;
            },
          );
        },
      ),
    );
  }
}
