// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task_planner/resources/button_demo.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/color_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/reminder_dropdown.dart';
import 'package:task_planner/resources/components/drop_down/repeat_drop_down.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/views/to_do_view/bloc/to_do_bloc.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/fonts/font_size.dart';
import '../../../views/planner_view/bloc/task_plan_bloc.dart';

class BottomSheets {
  static getBottomSheetForToDoList({
    required BuildContext context,
    required TextEditingController controller,
    required TextEditingController timeC,
    required TimeOfDay? pickedTime,
    required GlobalKey<FormState> formKey,
    required ToDoBloc toDoBloc,
    required String initialDropdownVal,
    required String initialReminderValue,
    required String initialRepeatVal,
    required ElevatedButton elevatedButton,
  }) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(builder: (context, setState) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("To Do Task",
                          style: FontSize.getMEdiumBlackFontstyle(context)),
                      getTextField(context, () => null, controller, "Add Task"),
                      getTimeRetrieverTextField(
                          context: context,
                          controller: timeC,
                          labelText: "Completion Time"),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text("Category  ",
                                  style:
                                      FontSize.getTextFieldTitleStyle(context)),
                              const SizedBox(width: 20),
                              CategoryDropDownList(
                                  categoryVal: initialDropdownVal),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("Reminder  ",
                                style:
                                    FontSize.getTextFieldTitleStyle(context)),
                            const SizedBox(width: 20),
                            ReminderDropdown(
                                reminderValue: initialReminderValue)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("Repeat  ",
                                style:
                                    FontSize.getTextFieldTitleStyle(context)),
                            const SizedBox(width: 20),
                            RepeatDropdown(repeatInitialValue: initialRepeatVal)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Buttons.getRectangleButton(context,
                              () => Navigator.of(context).pop(), "Cancel"),
                          elevatedButton
                        ],
                      ),
                    ],
                  ),
                );
              }),
            )).then((value) {
      controller.clear();
      timeC.clear();
    });
  }

  static getBottomSheetForPlanner(
          {required BuildContext context,
          required TextEditingController nameC,
          required TextEditingController startTimeC,
          required TextEditingController endTimeC,
          required TextEditingController descC,
          required GlobalKey<FormState> formKey,
          required TimeOfDay? pickedStartTime,
          required TimeOfDay? pickedEndTime,
          required TaskPlanBloc taskPlanBloc,
          required ElevatedButton bottomSheetButton,
          required String bottomSheetTitle,
          required String initialDropdownValue,
          required int hexColorCode}) =>
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bottomSheetTitle,
                            style: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle!
                                .copyWith(
                                    color: AppColors.kmainColor,
                                    fontWeight: FontWeight.w600)),
                      ),
                      getTextField(context, () {}, nameC, "Task Name"),
                      Row(
                        children: [
                          Expanded(
                              child: getTimeRetrieverTextField(
                                  context: context,
                                  controller: startTimeC,
                                  labelText: "Start Time")),
                          Expanded(
                              child: getTimeRetrieverTextField(
                                  context: context,
                                  controller: endTimeC,
                                  labelText: "End Time"))
                        ],
                      ),
                      getTextField(context, () {}, descC, "Description"),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Color",
                                    style: FontSize.getTextFieldTitleStyle(
                                        context)),
                                ColorDropDownList(hexCode: hexColorCode),
                              ],
                            )),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Category",
                                    style: FontSize.getTextFieldTitleStyle(
                                        context)),
                                CategoryDropDownList(
                                    categoryVal: initialDropdownValue),
                              ],
                            ))
                          ],
                        ),
                      ),
                      bottomSheetButton
                    ]),
              ),
            ),
          );
        },
      ).then((value) {
        nameC.clear();
        startTimeC.clear();
        endTimeC.clear();
        descC.clear();
      });

  static Widget getTextField(BuildContext context, Function() onTap,
          TextEditingController controller, String labelText) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            validator: (value) {
              if (value == "" || value == "null" || value!.isEmpty) {
                return "$labelText can not be empty";
              }
              return null;
            },
            controller: controller,
            autocorrect: false,
            onTap: onTap,
            cursorColor: AppColors.kmainColor,
            style: FontSize.getTextFieldTitleStyle(context),
            decoration: InputDecoration(
                labelText: labelText,
                labelStyle: FontSize.getTextFieldTitleStyle(context),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kmainColor)))),
      );

  static Widget getTimeRetrieverTextField(
      {required BuildContext context,
      required TextEditingController controller,
      required String labelText}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          autocorrect: false,
          readOnly: true,
          cursorColor: AppColors.kmainColor,
          style: FontSize.getTextFieldTitleStyle(context),
          onTap: () async {
            TimeOfDay? pickedStartTime = await showTimePicker(
                context: context,
                initialTime: controller.text == ""
                    ? TimeOfDay.now()
                    : Dates.getTimeInTimeOfDayFormat(controller.text));
            if (pickedStartTime != null) {
              controller.text = pickedStartTime.format(context);
            }
          },
          validator: (value) {
            if (value == "" || value == "null" || value!.isEmpty) {
              return "$labelText can not be empty";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: labelText,
              labelStyle: FontSize.getTextFieldTitleStyle(context),
              disabledBorder: const OutlineInputBorder(),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kmainColor)))),
    );
  }
}



// , () async {
//                             pickedStartTime = await showTimePicker(
//                                 context: context, initialTime: TimeOfDay.now());
//                             setState(() {
//                               startTimeC.text =
//                                   pickedStartTime!.format(context);
//                             });
//                           },