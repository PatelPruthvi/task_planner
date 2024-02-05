import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:task_planner/models/enum_models.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/category_view/ui/category_view.dart';
import 'package:task_planner/views/reminders_view/bloc/reminder_bloc.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({super.key});

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {
  final ReminderBloc reminderBloc = ReminderBloc();
  List<String> normalCategory = [
    "All",
    "Work",
    "Personal",
    "Wishlist",
    "Birthday"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text("Reminders"),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Dimensions.getScreenHeight(context) * 0.75,
            child: DefaultTabController(
              length: categories.length,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonsTabBar(
                          radius: 10,
                          height: Dimensions.getCategoryButtonsHeight(context),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: AppColors.kblue600,
                          unselectedBackgroundColor: AppColors.kwhiteColor,
                          labelStyle: FontSize.getMediumWhiteFontStyle(context),
                          unselectedLabelStyle:
                              FontSize.getToDoItemTileTextStyle(context),
                          tabs: [
                            Tab(text: "All"),
                            Tab(text: Models.getCategory(Category.work)),
                            Tab(text: Models.getCategory(Category.personal)),
                            Tab(text: Models.getCategory(Category.birthday)),
                            Tab(text: Models.getCategory(Category.wishlist))
                          ]),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CategoryView(
                              reminderBloc: reminderBloc,
                              event: ReminderInitialEvent()),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              event: ReminderCategoryChangedEvent(
                                  category: Models.getCategory(Category.work))),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              event: ReminderCategoryChangedEvent(
                                  category:
                                      Models.getCategory(Category.personal))),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              event: ReminderCategoryChangedEvent(
                                  category:
                                      Models.getCategory(Category.birthday))),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              event: ReminderCategoryChangedEvent(
                                  category:
                                      Models.getCategory(Category.wishlist))),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
