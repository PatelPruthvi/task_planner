// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_planner/utils/fonts/font_size.dart';

class SettingsPageButton extends StatelessWidget {
  const SettingsPageButton(
      {Key? key, required this.text, required this.press, required this.icon})
      : super(key: key);

  final String text;
  final VoidCallback? press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Theme.of(context).listTileTheme.tileColor),
        onPressed: press,
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).listTileTheme.textColor),
            const SizedBox(width: 10),
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        fontSize: FontSize.getMediumFontSize(context),
                        color: Theme.of(context).listTileTheme.textColor))),
            Icon(Icons.arrow_forward_ios,
                color: Theme.of(context).listTileTheme.textColor),
          ],
        ),
      ),
    );
  }
}
