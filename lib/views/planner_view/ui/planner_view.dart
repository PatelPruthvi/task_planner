import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:task_planner/resources/components/calendar/infinite_view_calendar.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/planner_view/bloc/task_plan_bloc.dart';
import 'package:task_planner/views/task_plan_view/ui/task_plan_view.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/dates/date_time.dart';
import '../../../utils/dimensions/dimensions.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({super.key});

  @override
  State<PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> {
  final HomeBloc homeBloc = HomeBloc();
  final TaskPlanBloc taskPlanBloc = TaskPlanBloc();
  final EasyInfiniteDateTimelineController _dateTimelineController =
      EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        toolbarHeight: Dimensions.getAppBarHeight(context),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Task Planner",
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
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
                  child: Icon(Icons.calendar_month_outlined),
                )),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              color: AppColors.kmainColor,
              child: InfiniteCalendar(
                  homeBloc: homeBloc,
                  dateController: _dateTimelineController,
                  taskPlanBloc: taskPlanBloc)),
          SizedBox(
              height: Dimensions.getTabBarViewHeight(context) * 0.95,
              child: TaskPlanView(homeBloc: homeBloc, taskBloc: taskPlanBloc))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.add_outlined, color: AppColors.kwhiteColor),
      //     onPressed: () {
      //       BottomSheets.getBottomSheetForToDoList(
      //           context: context,
      //           controller: todoController,
      //           timeC: timeC,
      //           pickedTime: timeOfDay,
      //           formKey: formKey,
      //           toDoBloc: toDoBloc,
      //           initialDropdownVal: categories[0],
      //           initialReminderValue: Models.getReminder(Reminder.sameTime),
      //           elevatedButton: Buttons.getRectangleButton(context, () {
      //             if (formKey.currentState?.validate() == true) {
      //               toDoBloc.add(ToDoAddTaskClickedEvent(
      //                 todoController.text,
      //                 CategoryDropDownList.getCategoryDropDownVal(),
      //                 timeC.text,
      //                 ReminderDropdown.getReminderVal(),
      //               ));
      //             }
      //           }, "Done"));
      //     }),
    );
  }
}
