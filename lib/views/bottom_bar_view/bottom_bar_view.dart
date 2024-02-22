import 'package:flutter/material.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/planner_view/ui/planner_view.dart';
import 'package:task_planner/views/reminders_view/ui/reminder_view.dart';
import 'package:task_planner/views/settings_view/ui/settings_view.dart';
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
      const PlannerView(),
      const SettingScreen()
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: widgets.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            FontDecors.getBottomNavBarSelectedTextStyle(context),
        unselectedLabelStyle:
            FontDecors.getBottomNavBarUnSelectedTextStyle(context),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_rounded), label: "Reminders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_rounded),
              label: "To Do List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_alt), label: "Task Planner"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
        currentIndex: selectedIndex,
        onTap: onBarChange,
      ),
    );
  }
}
