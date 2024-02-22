import 'package:flutter/material.dart';
import 'package:task_planner/models/reminder_model.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/views/reminders_view/bloc/reminder_bloc.dart';

class DialogBoxes {
  static getDialogBoxForInternetConnection(BuildContext context) {
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            icon: const Icon(Icons.network_check),
            title: const Text("No Internet", textAlign: TextAlign.center),
            content: const Text(
              "No connection, please check your internet connectivity.During initial setup, please ensure an internet connection for optimal functionality. After setup, the app operates seamlessly offline. Enjoy planning!",
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Okay!")),
            ],
          );
        });
  }

  static getAlertDialogForTaskDeletion(
      {required BuildContext context,
      required ReminderModel reminderItem,
      required ReminderBloc reminderBloc,
      String? category}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          icon: const Icon(Icons.info_outline),
          title: const Text(
              "Are you sure you want to delete this reminder? This is a repeating reminder.",
              textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            TextButton(
                onPressed: () {
                  // The same function as in completing repeat reminder will be used here
                  // as that function deletes the older task and scheduling next occuring one
                  //in the ToDOIthcheckBoxClickedEvent the iscompleted will automatically be opposite of it's
                  //current state so it is set to false, will eventually become true & this reminder will be deleted..
                  reminderItem.isCompleted = false;

                  if (category != null) {
                    reminderBloc.add(ReminderIthItemCheckBoxClickedEvent(
                        category: category, reminderItem: reminderItem));
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Delete This Reminder Only",
                    style: TextStyle(color: AppColors.kredColor))),
            TextButton(
                onPressed: () {
                  reminderBloc.add(ReminderDeleteItemPressedEvent(
                      category: category!, reminderItem: reminderItem));
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Delete All Future Reminders",
                  style: TextStyle(color: AppColors.kredColor),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"))
          ],
        );
      },
    );
  }

  static getAlertDialogForRepeatTaskCompletion(
      {required BuildContext context,
      required ReminderModel reminderItem,
      required ReminderBloc reminderBloc,
      required String category}) {
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            icon: const Icon(Icons.info_outline),
            title: const Text(
                "This is a repeating task. Completing this task will remove it, and the next occurence will be automatically scheduled. Continue?",
                textAlign: TextAlign.center),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    reminderBloc.add(ReminderIthItemCheckBoxClickedEvent(
                        category: category, reminderItem: reminderItem));

                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }
}
