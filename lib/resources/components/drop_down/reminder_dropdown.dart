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
    return DropdownButton(
        value: reminderVal,
        items: reminders.map((val) {
          return DropdownMenuItem(value: val, child: Text(val));
        }).toList(),
        onChanged: (val) {
          setState(() {
            reminderVal = val!;
          });
        });
  }
}
