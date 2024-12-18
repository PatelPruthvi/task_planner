import 'package:flutter/material.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import '../../../models/enum_models.dart';

String dropDownValue = "None";

class CategoryDropDownList extends StatefulWidget {
  final String categoryVal;
  const CategoryDropDownList({super.key, required this.categoryVal});

  @override
  State<CategoryDropDownList> createState() => _CategoryDropDownListState();
  static String getCategoryDropDownVal() => dropDownValue;
}

class _CategoryDropDownListState extends State<CategoryDropDownList> {
  @override
  void initState() {
    dropDownValue = widget.categoryVal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: DropdownButton(
          underline: const Text(""),
          iconEnabledColor: Theme.of(context).listTileTheme.textColor,
          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          value: dropDownValue,
          items: categories.map((val) {
            return DropdownMenuItem(
                value: val,
                child: Text(
                  val,
                  style: FontDecors.getDropdownTextStyle(context),
                ));
          }).toList(),
          onChanged: (val) {
            setState(() {
              dropDownValue = val!;
            });
          }),
    );
  }
}
