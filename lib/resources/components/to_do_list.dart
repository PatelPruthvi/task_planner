// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/resources/components/bottom_sheets/bottom_sheet_planner.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/fonts/font_size.dart';
import '../../views/to_do_view/bloc/to_do_bloc.dart';

// ignore: must_be_immutable
class ToDoListView extends StatelessWidget {
  List<ToDoModel> reminderItems;
  final ToDoBloc toDoBloc;
  ToDoListView({
    Key? key,
    required this.reminderItems,
    required this.toDoBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameC = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reminderItems.length,
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
                    //       todoItem: reminderItems[index]));
                    // }),
                    children: [
                      SlidableAction(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        onPressed: (context) {
                          toDoBloc.add(ToDoIthItemDeletedButtonClickedEvent(
                              todoItem: reminderItems[index]));
                        },
                        backgroundColor: AppColors.kredColor,
                        foregroundColor: AppColors.kwhiteColor,
                        icon: Icons.delete,
                      )
                    ]),
                child: InkWell(
                  onLongPress: () {
                    nameC.text = reminderItems[index].title!;

                    BottomSheets.getBottomSheetForToDoList(
                        context: context,
                        controller: nameC,
                        formKey: formKey,
                        toDoBloc: toDoBloc,
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            toDoBloc.add(ToDoIthItemUpdateClickedEvent(
                              title: nameC.text,
                              todoItem: reminderItems[index],
                            ));
                          }
                        },
                        buttonLabel: "Update");
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: reminderItems[index].isCompleted,
                      checkColor: AppColors.kwhiteColor,
                      activeColor: Theme.of(context).primaryColor,
                      side: BorderSide(
                          color: Theme.of(context).listTileTheme.textColor!,
                          width: 2),
                      onChanged: (value) {
                        toDoBloc.add(ToDoIthItemCheckBoxClickedEvent(
                            todoItem: reminderItems[index]));
                      },
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 0),
                      child: Text(
                        reminderItems[index].title.toString(),
                        style: FontSize.getToDoItemTileTextStyle(context),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
