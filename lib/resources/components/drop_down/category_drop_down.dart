import 'package:flutter/material.dart';
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
    return DropdownButton(
        value: dropDownValue,
        items: categories.map((val) {
          return DropdownMenuItem(value: val, child: Text(val));
        }).toList(),
        onChanged: (val) {
          setState(() {
            dropDownValue = val!;
          });
        });
  }
}
