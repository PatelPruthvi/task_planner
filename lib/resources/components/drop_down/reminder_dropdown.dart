import 'package:flutter/material.dart';
import '../../../models/enum_models.dart';

String reminderVal = Models.getReminder(Reminder.sameTime);

class ReminderDropdown extends StatefulWidget {
  final String reminderValue;
  const ReminderDropdown({super.key, required this.reminderValue});

  @override
  State<ReminderDropdown> createState() => _ReminderDropdownState();
  static String getReminderVal() => reminderVal;
}

class _ReminderDropdownState extends State<ReminderDropdown> {
  @override
  void initState() {
    reminderVal = widget.reminderValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: DropdownButton(
          isExpanded: true,
          alignment: Alignment.center,
          underline: const Text(""),
          iconEnabledColor: Theme.of(context).listTileTheme.textColor,
          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          value: reminderVal,
          items: reminders.map((val) {
            return DropdownMenuItem(
                value: val,
                child: Center(
                  child: Text(
                    val,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Theme.of(context).listTileTheme.textColor),
                  ),
                ));
          }).toList(),
          onChanged: (val) {
            setState(() {
              reminderVal = val!;
            });
          }),
    );
  }
}
