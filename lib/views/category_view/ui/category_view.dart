import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/reminders_view/bloc/reminder_bloc.dart';

class CategoryView extends StatefulWidget {
  final ReminderEvent event;
  final ReminderBloc reminderBloc;
  const CategoryView(
      {super.key, required this.event, required this.reminderBloc});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    widget.reminderBloc.add(widget.event);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: BlocBuilder<ReminderBloc, ReminderState>(
        bloc: widget.reminderBloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case ReminderEmptyLoadedState:
              return Center(
                child: Text(
                  "No reminders found...",
                  style: FontSize.getMEdiumBlackFontstyle(context),
                ),
              );
            case ReminderLoadedSuccessState:
              final successState = state as ReminderLoadedSuccessState;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: successState.todoItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            Dates.getDateInMdy(
                                successState.todoItems[index].date!),
                            style: FontSize.getToDoItemTileTextStyle(context)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: AppColors.kwhiteColor,
                          leading: Checkbox(
                              value: successState.todoItems[index].isCompleted!,
                              onChanged: (val) {}),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(successState.todoItems[index].title!),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.timer_outlined),
                                        const Text("  "),
                                        Text(successState
                                            .todoItems[index].completionTime!)
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.repeat),
                                        Text("   "),
                                        Text("-")
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          trailing:
                              Text(successState.todoItems[index].category!),
                        ),
                      )
                    ],
                  );
                },
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
