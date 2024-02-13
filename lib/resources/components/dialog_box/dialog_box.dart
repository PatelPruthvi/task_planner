import 'package:flutter/material.dart';
import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/views/reminders_view/bloc/reminder_bloc.dart';
import 'package:task_planner/views/to_do_view/bloc/to_do_bloc.dart';

class DialogBoxes {
  static getAlertDialogForTaskDeletion(
      {required BuildContext context,
      required ToDo todoItem,
      ToDoBloc? todoBloc,
      ReminderBloc? reminderBloc,
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
                  todoItem.isCompleted = false;
                  if (todoBloc != null) {
                    todoBloc.add(
                        ToDoIthItemCheckBoxClickedEvent(todoItem: todoItem));
                  }
                  if (reminderBloc != null && category != null) {
                    reminderBloc.add(ReminderIthItemCheckBoxClickedEvent(
                        category: category, todoItem: todoItem));
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Delete This Reminder Only",
                    style: TextStyle(color: AppColors.kredColor))),
            TextButton(
                onPressed: () {
                  todoBloc?.add(
                      ToDoIthItemDeletedButtonClickedEvent(todoItem: todoItem));
                  reminderBloc?.add(ReminderDeleteItemPressedEvent(
                      category: category!, todoItem: todoItem));
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
                child: const Text("CANCEL"))
          ],
        );
      },
    );
  }

  static getAlertDialogForRepeatTaskCompletion(
      {required BuildContext context,
      required ToDo todoItem,
      ToDoBloc? todoBloc,
      ReminderBloc? reminderBloc,
      String? category}) {
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
                    if (todoBloc != null) {
                      todoBloc.add(
                          ToDoIthItemCheckBoxClickedEvent(todoItem: todoItem));
                    }
                    if (reminderBloc != null && category != null) {
                      reminderBloc.add(ReminderIthItemCheckBoxClickedEvent(
                          category: category, todoItem: todoItem));
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }
}
