// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/color_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/reminder_dropdown.dart';
import 'package:task_planner/resources/components/drop_down/repeat_drop_down.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/views/reminders_view/bloc/reminder_bloc.dart';
import 'package:task_planner/views/to_do_view/bloc/to_do_bloc.dart';
import '../../../utils/fonts/font_size.dart';
import '../../../views/planner_view/bloc/task_plan_bloc.dart';

class BottomSheets {
  static getBottomSheetForToDoList(
      {required BuildContext context,
      required TextEditingController controller,
      required TextEditingController timeC,
      required TimeOfDay? pickedTime,
      required GlobalKey<FormState> formKey,
      required ToDoBloc toDoBloc,
      required String initialDropdownVal,
      required String initialReminderValue,
      required String initialRepeatVal,
      required Function() onPressed,
      required String buttonLabel}) {
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 5,
              strokeAlign: 1,
            )),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("To Do Task",
                                  style: FontSize.getMEdiumBlackFontstyle(
                                      context)),
                              getTextField(
                                  context, () => null, controller, "Add Task"),
                              getTimeRetrieverTextField(
                                  context: context,
                                  controller: timeC,
                                  labelText: "Completion Time"),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Category",
                                              style: FontSize
                                                      .getTextFieldTitleStyle(
                                                          context)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20),
                                          CategoryDropDownList(
                                              categoryVal: initialDropdownVal),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Repeat",
                                              style: FontSize
                                                      .getTextFieldTitleStyle(
                                                          context)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                          Dimensions.getSmallerSizedBox(
                                              context),
                                          RepeatDropdown(
                                              repeatInitialValue:
                                                  initialRepeatVal)
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Reminder",
                                        style: FontSize.getTextFieldTitleStyle(
                                                context)
                                            .copyWith(
                                                fontWeight: FontWeight.w600)),
                                    Dimensions.getSmallerSizedBox(context),
                                    Expanded(
                                      child: ReminderDropdown(
                                          reminderValue: initialReminderValue),
                                    ),
                                    Dimensions.getSmallerSizedBox(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: onPressed,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(buttonLabel,
                                        textAlign: TextAlign.center,
                                        style: FontSize
                                            .getBottomSheetButtonTextStyle(
                                                context)),
                                  ),
                                )),
                                VerticalDivider(
                                  thickness: 3,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Cancel",
                                        textAlign: TextAlign.center,
                                        style: FontSize
                                            .getBottomSheetButtonTextStyle(
                                                context)),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
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
          required String bottomSheetTitle,
          required String initialDropdownValue,
          required int hexColorCode,
          required Function() onTap,
          required String buttonLabel}) =>
      showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 5,
              strokeAlign: 1,
            )),
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
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
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
                                          color:
                                              Theme.of(context).iconTheme.color,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("Color",
                                          style:
                                              FontSize.getTextFieldTitleStyle(
                                                  context)),
                                      Dimensions.getSmallerSizedBox(context),
                                      ColorDropDownList(hexCode: hexColorCode),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Category",
                                          style:
                                              FontSize.getTextFieldTitleStyle(
                                                  context)),
                                      Dimensions.getSmallerSizedBox(context),
                                      CategoryDropDownList(
                                          categoryVal: initialDropdownValue),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          width: Dimensions.getScreenWidth(context),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(buttonLabel,
                                  style: FontSize.getBottomSheetButtonTextStyle(
                                      context)),
                            ),
                          ),
                        ),
                      ),
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
            cursorColor: Theme.of(context).primaryColor,
            style: FontSize.getTextFieldTitleStyle(context),
            decoration: InputDecoration(labelText: labelText)),
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
          cursorColor: Theme.of(context).primaryColor,
          style: FontSize.getTextFieldTitleStyle(context),
          onTap: () async {
            TimeOfDay? pickedStartTime = await showTimePicker(
              context: context,
              initialTime: controller.text == ""
                  ? TimeOfDay.now()
                  : Dates.getTimeInTimeOfDayFormat(controller.text),
            );
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
          decoration: InputDecoration(labelText: labelText)),
    );
  }

  static getBottomSheetForDateWiseTodo(
      {required BuildContext context,
      required TextEditingController controller,
      required TextEditingController timeC,
      required TextEditingController dateC,
      required TimeOfDay? pickedTime,
      required DateTime? dateTime,
      required GlobalKey<FormState> formKey,
      required ReminderBloc reminderBloc,
      required String initialDropdownVal,
      required String initialReminderValue,
      required String initialRepeatVal,
      required Function() onPressed,
      required String buttonLabel}) {
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 5,
                strokeAlign: 1)),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("To Do Task",
                                style:
                                    FontSize.getMEdiumBlackFontstyle(context)),
                            getTextField(
                                context, () => null, controller, "Add Task"),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                        controller: dateC,
                                        autocorrect: false,
                                        readOnly: true,
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        style: FontSize.getTextFieldTitleStyle(
                                            context),
                                        onTap: () async {
                                          dateTime = await showDatePicker(
                                            context: context,
                                            initialDate: dateC.text != ""
                                                ? DateTime.parse(dateC.text)
                                                : DateTime.now(),
                                            firstDate: Dates.startDay,
                                            lastDate: Dates.endDay,
                                          );

                                          if (dateTime != null) {
                                            dateC.text = dateTime
                                                .toString()
                                                .substring(0, 10);
                                          }
                                        },
                                        validator: (value) {
                                          if (value == "" ||
                                              value == "null" ||
                                              value!.isEmpty) {
                                            return "Date can not be empty";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            labelText: "Add Date")),
                                  ),
                                ),
                                Expanded(
                                  child: getTimeRetrieverTextField(
                                      context: context,
                                      controller: timeC,
                                      labelText: "Completion Time"),
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Category",
                                            style:
                                                FontSize.getTextFieldTitleStyle(
                                                        context)
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600)),
                                        Dimensions.getSmallerSizedBox(context),
                                        CategoryDropDownList(
                                            categoryVal: initialDropdownVal),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Repeat",
                                            style:
                                                FontSize.getTextFieldTitleStyle(
                                                        context)
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600)),
                                        Dimensions.getSmallerSizedBox(context),
                                        RepeatDropdown(
                                            repeatInitialValue:
                                                initialRepeatVal)
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Reminder",
                                      style: FontSize.getTextFieldTitleStyle(
                                              context)
                                          .copyWith(
                                              fontWeight: FontWeight.w600)),
                                  Dimensions.getSmallerSizedBox(context),
                                  Expanded(
                                    child: ReminderDropdown(
                                        reminderValue: initialReminderValue),
                                  ),
                                  Dimensions.getSmallerSizedBox(context)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: onPressed,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(buttonLabel,
                                      textAlign: TextAlign.center,
                                      style: FontSize
                                          .getBottomSheetButtonTextStyle(
                                              context)),
                                ),
                              )),
                              VerticalDivider(
                                thickness: 3,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Cancel",
                                      textAlign: TextAlign.center,
                                      style: FontSize
                                          .getBottomSheetButtonTextStyle(
                                              context)),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Buttons.getRectangleButton(context,
                      //         () => Navigator.of(context).pop(), "Cancel"),
                      //     elevatedButton
                      //   ],
                      // ),
                    ],
                  ),
                );
              }),
            )).then((value) {
      controller.clear();
      timeC.clear();
      dateC.clear();
    });
  }
}
