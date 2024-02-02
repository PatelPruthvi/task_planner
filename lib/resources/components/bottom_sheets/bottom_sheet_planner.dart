import 'package:flutter/material.dart';
import 'package:task_planner/resources/button_demo.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/color_drop_down.dart';
import 'package:task_planner/views/task_plan_view/bloc/task_plan_bloc.dart';
import 'package:task_planner/views/todo_view/bloc/to_do_bloc.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/fonts/font_size.dart';

class BottomSheets {
  static getBottomSheetForToDoList(
      BuildContext context,
      TextEditingController controller,
      TextEditingController timeC,
      TimeOfDay? pickedTime,
      GlobalKey<FormState> formKey,
      ToDoBloc toDoBloc,
      String initialDropdownVal,
      ElevatedButton elevatedButton) {
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
                      getTextField(context, () async {
                        pickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        setState(() {
                          timeC.text = pickedTime!.format(context);
                        });
                      }, timeC, "Start Time"),
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
          BuildContext context,
          TextEditingController nameC,
          TextEditingController startTimeC,
          TextEditingController endTimeC,
          TextEditingController descC,
          GlobalKey<FormState> formKey,
          TimeOfDay? pickedStartTime,
          TimeOfDay? pickedEndTime,
          TaskPlanBloc taskPlanBloc,
          ElevatedButton bottomSheetButton,
          String bottomSheetTitle,
          String initialDropdownValue,
          int hexColorCode) =>
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
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w600)),
                      ),
                      getTextField(context, () {}, nameC, "Task Name"),
                      Row(
                        children: [
                          Expanded(
                              child: getTextField(context, () async {
                            pickedStartTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            setState(() {
                              startTimeC.text =
                                  pickedStartTime!.format(context);
                            });
                          }, startTimeC, "Start Time")),
                          Expanded(
                              child: getTextField(context, () async {
                            pickedEndTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());

                            setState(() {
                              endTimeC.text = pickedEndTime!.format(context);
                            });
                          }, endTimeC, "End Time")),
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
}

Widget getTextField(BuildContext context, Function() onTap,
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
          cursorColor: AppColors.mainColor,
          style: FontSize.getTextFieldTitleStyle(context),
          decoration: InputDecoration(
              labelText: labelText,
              labelStyle: FontSize.getTextFieldTitleStyle(context),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor)))),
    );
