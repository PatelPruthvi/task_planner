import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/resources/components/calendar/infinite_view_calendar.dart';
import 'package:task_planner/resources/components/drop_down/repeat_drop_down.dart';
import 'package:task_planner/resources/components/to_do_list.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/to_do_view/bloc/to_do_bloc.dart';
import '../../../models/enum_models.dart';
import '../../../resources/components/bottom_sheets/bottom_sheet_planner.dart';
import '../../../resources/components/drop_down/category_drop_down.dart';
import '../../../resources/components/drop_down/reminder_dropdown.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/dates/date_time.dart';
import '../../../utils/dimensions/dimensions.dart';
import '../../../utils/widgets/utils.dart';

class ToDoWidget extends StatefulWidget {
  const ToDoWidget({super.key});

  @override
  State<ToDoWidget> createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
  final HomeBloc homeBloc = HomeBloc();
  final ToDoBloc toDoBloc = ToDoBloc();
  final EasyInfiniteDateTimelineController _dateTimelineController =
      EasyInfiniteDateTimelineController();
  DateTime currentDate = Dates.today;
  TextEditingController todoController = TextEditingController();
  TextEditingController timeC = TextEditingController();
  TimeOfDay timeOfDay = TimeOfDay.now();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool areCompletedItemsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Dimensions.getAppBarHeight(context),
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Utils.getAppLogoForAppBar(context),
                const SizedBox(width: 10),
                const Text("To-Do List")
              ],
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  DateTime? dateTime = await showDatePicker(
                      context: context,
                      firstDate: Dates.startDay,
                      lastDate: Dates.endDay,
                      initialDate: InfiniteCalendar.getSelectedDateTime());
                  if (dateTime != null) {
                    _dateTimelineController.animateToDate(dateTime);
                    homeBloc.add(
                        HomeCalendarDateTappedEvent(selectedDate: dateTime));
                  }
                },
                child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.calendar_month_outlined))),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              color: Theme.of(context).primaryColor,
              child: InfiniteCalendar(
                  homeBloc: homeBloc,
                  dateController: _dateTimelineController,
                  toDoBloc: toDoBloc)),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: BlocConsumer<ToDoBloc, ToDoState>(
                bloc: toDoBloc,
                buildWhen: (previous, current) => current is! ToDoActionState,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case ToDoListEmptyState:
                      return Center(
                          child: SizedBox(
                        height: Dimensions.getTabBarViewHeight(context) * 0.95,
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
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ToDoListView(
                              todoItems: successState.todoPendingItems,
                              toDoBloc: toDoBloc),
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
                                          style:
                                              FontSize.getToDoItemTileTextStyle(
                                                  context)),
                                      Icon(
                                          areCompletedItemsVisible
                                              ? Icons.keyboard_arrow_up_outlined
                                              : Icons
                                                  .keyboard_arrow_down_outlined,
                                          color: Theme.of(context)
                                              .listTileTheme
                                              .textColor)
                                    ])),
                          ),
                          areCompletedItemsVisible
                              ? ToDoListView(
                                  todoItems: successState.todoCompletedItems,
                                  toDoBloc: toDoBloc)
                              : Container(),
                        ],
                      );
                    default:
                      return Container();
                  }
                },
                listenWhen: (previous, current) => current is ToDoActionState,
                listener: (context, state) {
                  if (state is ToDoCloseSheetActionState) {
                    Navigator.of(context).pop();

                    toDoBloc.add(ToDoInitialEvent());
                  } else if (state is ToDoShowErrorMsgActionState) {
                    Utils.flushBarErrorMsg(state.errorMsg, context);
                  }
                },
              ),
            ),
          ),
          // SizedBox(
          //     height: Dimensions.getTabBarViewHeight(context) * 0.95,
          //     child: ToDoScreen(homeBloc: homeBloc, toDoBloc: toDoBloc))
        ],
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
                toDoBloc: toDoBloc,
                initialDropdownVal: categories[0],
                initialReminderValue: Models.getReminder(Reminder.sameTime),
                initialRepeatVal: "Never",
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    toDoBloc.add(ToDoAddTaskClickedEvent(
                        todoController.text,
                        CategoryDropDownList.getCategoryDropDownVal(),
                        timeC.text,
                        ReminderDropdown.getReminderVal(),
                        RepeatDropdown.getRepeatVal()));
                  }
                },
                buttonLabel: "Done");
          }),
    );
  }
}
