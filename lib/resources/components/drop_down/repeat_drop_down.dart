import 'package:flutter/material.dart';
import '../../../models/enum_models.dart';

String repeatValue = "Never";

class RepeatDropdown extends StatefulWidget {
  final String repeatInitialValue;
  const RepeatDropdown({super.key, required this.repeatInitialValue});

  @override
  State<RepeatDropdown> createState() => _RepeatDropdownState();
  static String getRepeatVal() => repeatValue;
}

class _RepeatDropdownState extends State<RepeatDropdown> {
  @override
  void initState() {
    repeatValue = widget.repeatInitialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: DropdownButton(
          borderRadius: BorderRadius.circular(15),
          underline: const Text(""),
          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
          iconEnabledColor: Theme.of(context).listTileTheme.textColor,
          value: repeatValue,
          items: repeats.map((val) {
            return DropdownMenuItem(
                value: val,
                child: Text(
                  val,
                  style: TextStyle(
                      color: Theme.of(context).listTileTheme.textColor),
                ));
          }).toList(),
          onChanged: (val) {
            setState(() {
              repeatValue = val!;
            });
          }),
    );
  }
}
