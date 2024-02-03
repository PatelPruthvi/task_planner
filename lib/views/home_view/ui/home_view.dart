import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:task_planner/resources/components/calendar/main_cal.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/task_plan_view/bloc/task_plan_bloc.dart';
import 'package:task_planner/views/task_plan_view/ui/task_plan_view.dart';
import 'package:task_planner/views/todo_view/bloc/to_do_bloc.dart';
import 'package:task_planner/views/todo_view/ui/todo_view.dart';
import '../../../utils/dimensions/dimensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();
  final ToDoBloc toDoBloc = ToDoBloc();
  final TaskPlanBloc taskBloc = TaskPlanBloc();
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
          child: Text("Task Manager",
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
                      initialDate: HomeCal.getSelectedDateTime());
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
              child: HomeCal(
                homeBloc: homeBloc,
                toDoBloc: toDoBloc,
                taskBloc: taskBloc,
                dateController: _dateTimelineController,
              )),
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.kmainColor,
                  child: TabBar(
                      indicatorColor: AppColors.kwhiteColor,
                      dividerHeight: 0,
                      padding: const EdgeInsets.only(bottom: 5),
                      tabs: [
                        Text("To Do List",
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle),
                        Text("Task Planner",
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle),
                      ]),
                ),
                SizedBox(
                  height: Dimensions.getTabBarViewHeight(context),
                  child: TabBarView(
                    children: [
                      ToDoScreen(homeBloc: homeBloc, toDoBloc: toDoBloc),
                      TaskPlanView(homeBloc: homeBloc, taskBloc: taskBloc)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
