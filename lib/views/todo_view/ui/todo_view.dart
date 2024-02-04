import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/models/enum_models.dart';
import 'package:task_planner/resources/button_demo.dart';
import 'package:task_planner/resources/components/bottom_sheets/bottom_sheet_planner.dart';
import 'package:task_planner/resources/components/drop_down/category_drop_down.dart';
import 'package:task_planner/resources/components/drop_down/reminder_dropdown.dart';
import 'package:task_planner/resources/components/to_do_list.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/utils/widgets/util_widgets.dart';
import 'package:task_planner/views/todo_view/bloc/to_do_bloc.dart';
import '../../home_view/bloc/home_bloc.dart';

class ToDoScreen extends StatefulWidget {
  final HomeBloc homeBloc;
  final ToDoBloc toDoBloc;
  const ToDoScreen({super.key, required this.homeBloc, required this.toDoBloc});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  DateTime currentDate = Dates.today;
  TextEditingController todoController = TextEditingController();
  TextEditingController timeC = TextEditingController();
  TimeOfDay timeOfDay = TimeOfDay.now();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool areCompletedItemsVisible = false;

  @override
  void initState() {
    widget.toDoBloc.add(ToDoInitialEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocConsumer<ToDoBloc, ToDoState>(
          bloc: widget.toDoBloc,
          buildWhen: (previous, current) => current is! ToDoActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case ToDoListEmptyState:
                return Center(
                    child: SizedBox(
                  height: Dimensions.getTabBarViewHeight(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Pending Tasks...",
                        style: FontSize.getToDoItemTileTextStyle(context),
                      ),
                    ],
                  ),
                ));
              case ToDoListLoadedSuccessState:
                final successState = state as ToDoListLoadedSuccessState;
                return SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ToDoListView(
                          todoItems: successState.todoPendingItems,
                          toDoBloc: widget.toDoBloc),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                areCompletedItemsVisible =
                                    !areCompletedItemsVisible;
                              });
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("COMPLETED TASKS",
                                      style: FontSize.getToDoItemTileTextStyle(
                                          context)),
                                  Icon(
                                      areCompletedItemsVisible
                                          ? Icons.keyboard_arrow_up_outlined
                                          : Icons.keyboard_arrow_down_outlined,
                                      color: Colors.black)
                                ])),
                      ),
                      areCompletedItemsVisible
                          ? ToDoListView(
                              todoItems: successState.todoCompletedItems,
                              toDoBloc: widget.toDoBloc)
                          : Container(),
                    ],
                  ),
                );
              default:
                return Container();
            }
          },
          listenWhen: (previous, current) => current is ToDoActionState,
          listener: (context, state) {
            if (state is ToDoCloseSheetActionState) {
              Navigator.of(context).pop();

              widget.toDoBloc.add(ToDoInitialEvent());
            } else if (state is ToDoShowErrorMsgActionState) {
              Utils.flushBarErrorMsg(state.errorMsg, context);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_outlined, color: AppColors.kwhiteColor),
          onPressed: () {
            BottomSheets.getBottomSheetForToDoList(
                context: context,
                controller: todoController,
                timeC: timeC,
                pickedTime: timeOfDay,
                formKey: formKey,
                toDoBloc: widget.toDoBloc,
                initialDropdownVal: categories[0],
                initialReminderValue: Models.getReminder(Reminder.sameTime),
                elevatedButton: Buttons.getRectangleButton(context, () {
                  if (formKey.currentState?.validate() == true) {
                    widget.toDoBloc.add(ToDoAddTaskClickedEvent(
                      todoController.text,
                      CategoryDropDownList.getCategoryDropDownVal(),
                      timeC.text,
                      ReminderDropdown.getReminderVal(),
                    ));
                  }
                }, "Done"));
          }),
    );
  }
}
