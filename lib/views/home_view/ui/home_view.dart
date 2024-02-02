import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_planner/resources/components/calendar/calendar_montly.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.mainColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: Dimensions.getSafeAreaHeight(context)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Task Manager",
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                      InkWell(
                        onTap: () {
                          if (CalendarView.getSelectedDateTime()
                                  .compareTo(Dates.today) !=
                              0) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          }
                        },
                        child: Text(DateFormat("d MMM").format(Dates.today),
                            style: FontSize.getMediumWhiteFontStyle(context)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              color: AppColors.mainColor,
              child: CalendarView(
                  homeBloc: homeBloc, toDoBloc: toDoBloc, taskBloc: taskBloc)),
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.mainColor,
                  child: TabBar(
                      indicatorColor: AppColors.whiteColor,
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
