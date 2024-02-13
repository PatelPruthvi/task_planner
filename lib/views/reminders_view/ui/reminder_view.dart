import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:task_planner/models/enum_models.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/utils/widgets/utils.dart';
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
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Utils.getAppLogoForAppBar(context),
                const SizedBox(width: 10),
                const Text("Reminders")
              ],
            )),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: DefaultTabController(
              length: categories.length,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonsTabBar(
                          radius: 10,
                          height: Dimensions.getCategoryButtonsHeight(context),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: Theme.of(context).primaryColor,
                          unselectedBackgroundColor:
                              Theme.of(context).listTileTheme.tileColor,
                          labelStyle: FontSize.getMediumWhiteFontStyle(context),
                          unselectedLabelStyle:
                              FontSize.getToDoItemTileTextStyle(context),
                          tabs: [
                            const Tab(text: "All"),
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
                            event: ReminderInitialEvent(),
                            category: "All",
                          ),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              category: Models.getCategory(Category.work),
                              event: ReminderCategoryChangedEvent(
                                  category: Models.getCategory(Category.work))),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              category: Models.getCategory(Category.personal),
                              event: ReminderCategoryChangedEvent(
                                  category:
                                      Models.getCategory(Category.personal))),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              category: Models.getCategory(Category.birthday),
                              event: ReminderCategoryChangedEvent(
                                  category:
                                      Models.getCategory(Category.birthday))),
                          CategoryView(
                              reminderBloc: reminderBloc,
                              category: Models.getCategory(Category.wishlist),
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
