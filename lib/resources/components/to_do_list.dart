// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/resources/button_demo.dart';
import 'package:task_planner/resources/components/bottom_sheets/bottom_sheet_planner.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/fonts/font_size.dart';
import '../../views/to_do_view/bloc/to_do_bloc.dart';

// ignore: must_be_immutable
class ToDoListView extends StatelessWidget {
  List<ToDo> todoItems;
  final ToDoBloc toDoBloc;
  ToDoListView({
    Key? key,
    required this.todoItems,
    required this.toDoBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameC = TextEditingController();
    TextEditingController timeC = TextEditingController();
    TimeOfDay timeOfDay = TimeOfDay.now();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                    extentRatio: 0.2,
                    motion: const ScrollMotion(),
                    //drag to delete functionality
                    // dismissible: DismissiblePane(onDismissed: () {
                    //   toDoBloc.add(ToDoIthItemDeletedButtonClickedEvent(
                    //       todoItem: todoItems[index]));
                    // }),
                    children: [
                      SlidableAction(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        onPressed: (context) {
                          toDoBloc.add(ToDoIthItemDeletedButtonClickedEvent(
                              todoItem: todoItems[index]));
                        },
                        backgroundColor: AppColors.kredColor,
                        foregroundColor: AppColors.kwhiteColor,
                        icon: Icons.delete,
                      )
                    ]),
                child: InkWell(
                  onLongPress: () {
                    nameC.text = todoItems[index].title!;
                    timeC.text = todoItems[index].completionTime!;
                    BottomSheets.getBottomSheetForToDoList(
                        context: context,
                        controller: nameC,
                        timeC: timeC,
                        pickedTime: timeOfDay,
                        formKey: formKey,
                        toDoBloc: toDoBloc,
                        initialDropdownVal: todoItems[index].category!,
                        initialReminderValue: todoItems[index].reminder!,
                        initialRepeatVal: todoItems[index].repeat!,
                        elevatedButton: Buttons.getRectangleButton(context, () {
                          if (formKey.currentState?.validate() == true) {
                            toDoBloc.add(ToDoIthItemUpdateClickedEvent(
                              title: nameC.text,
                              time: timeC.text,
                              todoItem: todoItems[index],
                            ));
                          }
                        }, "Update"));
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: todoItems[index].isCompleted,
                      checkColor: AppColors.kwhiteColor,
                      activeColor: AppColors.kmainColor,
                      onChanged: (value) {
                        toDoBloc.add(ToDoIthItemCheckBoxClickedEvent(
                            todoItem: todoItems[index]));
                      },
                    ),
                    title: Text(
                      todoItems[index].title.toString(),
                      style: FontSize.getToDoItemTileTextStyle(context),
                    ),
                    subtitle: Text(todoItems[index].category ?? ""),
                    trailing: Text(todoItems[index].completionTime ?? " "),
                    tileColor: AppColors.kwhiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ));
        });
  }
}
