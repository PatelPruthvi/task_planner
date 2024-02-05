import 'package:flutter/material.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/planner_view/ui/planner_view.dart';
import 'package:task_planner/views/reminders_view/ui/reminder_view.dart';
import 'package:task_planner/views/to_do_view/ui/to_do_view.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  int selectedIndex = 1;

  void onBarChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      const ReminderView(),
      const ToDoWidget(),
      const PlannerView()
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: widgets.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.kscreenColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_filled_sharp), label: "Reminders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_sharp), label: "To Do List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check_circle_sharp),
              label: "Task Planner")
        ],
        selectedItemColor: AppColors.kblue600,
        selectedFontSize: 16,
        unselectedFontSize: 12,
        selectedLabelStyle: FontSize.getTextFieldTitleStyle(context),
        currentIndex: selectedIndex,
        onTap: onBarChange,
      ),
    );
  }
}
