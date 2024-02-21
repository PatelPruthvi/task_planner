import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_planner/models/reminder_model.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/reminders_view/bloc/reminder_bloc.dart';
import '../../../models/enum_models.dart';
import '../../../resources/components/bottom_sheets/bottom_sheet_planner.dart';
import '../../../resources/components/dialog_box/dialog_box.dart';
import '../../../resources/components/drop_down/category_drop_down.dart';
import '../../../resources/components/drop_down/reminder_dropdown.dart';
import '../../../resources/components/drop_down/repeat_drop_down.dart';

class CategoryView extends StatefulWidget {
  final ReminderEvent event;
  final ReminderBloc reminderBloc;
  final String category;
  const CategoryView(
      {super.key,
      required this.event,
      required this.reminderBloc,
      required this.category});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  TextEditingController todoController = TextEditingController();
  TextEditingController timeC = TextEditingController();
  TextEditingController dateC = TextEditingController();
  TimeOfDay timeOfDay = TimeOfDay.now();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.reminderBloc.add(widget.event);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<ReminderBloc, ReminderState>(
          bloc: widget.reminderBloc,
          buildWhen: (previous, current) => current is! ReminderActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case ReminderEmptyLoadedState:
                return Center(
                  child: Text(
                    "No Reminders Found...",
                    style: FontSize.getToDoItemTileTextStyle(context),
                  ),
                );
              case ReminderLoadedSuccessState:
                final successState = state as ReminderLoadedSuccessState;
                List<bool> isVisible =
                    List.filled(successState.reminderItems.length, true);
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: StatefulBuilder(builder: (context, setState) {
                    return ListView.builder(
                      itemCount: successState.reminderItems.length,
                      itemBuilder: (context, index) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isVisible[index] = !isVisible[index];
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          Dates.getDateInMdy(successState
                                              .reminderItems[index][0].date!),
                                          style: TextStyle(
                                              fontSize: FontSize
                                                  .getTaskPlannerDescriptionFontSize(
                                                      context))),
                                      Icon(isVisible[index]
                                          ? Icons.keyboard_arrow_down_outlined
                                          : Icons.keyboard_arrow_up_outlined),
                                    ],
                                  ),
                                ),
                              ),
                              isVisible[index]
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: successState
                                          .reminderItems[index].length,
                                      itemBuilder: (context, i) {
                                        ReminderModel reminderItem =
                                            successState.reminderItems[index]
                                                [i];

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 5),
                                          child: Slidable(
                                            key: ValueKey(2 + index),
                                            endActionPane: ActionPane(
                                                extentRatio: 0.2,
                                                motion: const ScrollMotion(),
                                                //drag to delete functionality
                                                // dismissible: DismissiblePane(onDismissed: () {
                                                //   toDoBloc.add(ToDoIthItemDeletedButtonClickedEvent(
                                                //       reminderItem: reminderItems[index]));
                                                // }),
                                                children: [
                                                  SlidableAction(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                      onPressed: (context) {
                                                        if (reminderItem
                                                                .repeat ==
                                                            "Never") {
                                                          widget.reminderBloc.add(
                                                              ReminderDeleteItemPressedEvent(
                                                                  reminderItem:
                                                                      reminderItem,
                                                                  category: widget
                                                                      .category));
                                                        } else {
                                                          DialogBoxes.getAlertDialogForTaskDeletion(
                                                              context: context,
                                                              reminderItem:
                                                                  reminderItem,
                                                              reminderBloc: widget
                                                                  .reminderBloc,
                                                              category: widget
                                                                  .category);
                                                        }
                                                      },
                                                      backgroundColor:
                                                          AppColors.kredColor,
                                                      foregroundColor:
                                                          AppColors.kwhiteColor,
                                                      icon: Icons.delete)
                                                ]),
                                            child: InkWell(
                                              onLongPress: () {
                                                todoController.text =
                                                    reminderItem.title ?? " ";
                                                timeC.text = reminderItem
                                                        .completionTime ??
                                                    "00:00";
                                                dateC.text =
                                                    reminderItem.date ??
                                                        "0000-00-00";
                                                BottomSheets
                                                    .getBottomSheetForDateWiseTodo(
                                                  context: context,
                                                  controller: todoController,
                                                  timeC: timeC,
                                                  dateC: dateC,
                                                  pickedTime: Dates
                                                      .getTimeInTimeOfDayFormat(
                                                          reminderItem
                                                              .completionTime!),
                                                  dateTime: DateTime.now(),
                                                  formKey: formKey,
                                                  reminderBloc:
                                                      widget.reminderBloc,
                                                  initialDropdownVal:
                                                      reminderItem.category!,
                                                  initialReminderValue:
                                                      reminderItem.reminder!,
                                                  initialRepeatVal:
                                                      reminderItem.repeat!,
                                                  onPressed: () {
                                                    widget.reminderBloc.add(
                                                        ReminderIthItemUpdateClickedEvent(
                                                            title:
                                                                todoController
                                                                    .text,
                                                            time: timeC.text,
                                                            reminderItem:
                                                                reminderItem,
                                                            category:
                                                                widget.category,
                                                            dateTime:
                                                                dateC.text));
                                                  },
                                                  buttonLabel: "Update",
                                                );
                                              },
                                              child: ListTile(
                                                leading: Checkbox(
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .listTileTheme
                                                          .textColor!,
                                                      width: 2,
                                                    ),
                                                    activeColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    value: reminderItem
                                                        .isCompleted!,
                                                    onChanged: (val) {
                                                      if (reminderItem.repeat ==
                                                          "Never") {
                                                        widget.reminderBloc.add(
                                                            ReminderIthItemCheckBoxClickedEvent(
                                                                reminderItem:
                                                                    reminderItem,
                                                                category: widget
                                                                    .category));
                                                      } else {
                                                        DialogBoxes.getAlertDialogForRepeatTaskCompletion(
                                                            context: context,
                                                            reminderItem:
                                                                reminderItem,
                                                            reminderBloc: widget
                                                                .reminderBloc,
                                                            category: widget
                                                                .category);
                                                      }
                                                    }),
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Text(reminderItem.title!),
                                                ),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Icon(Icons
                                                                  .timer_outlined),
                                                              Text(reminderItem
                                                                  .completionTime!)
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Icon(
                                                                  Icons.repeat),
                                                              Text(reminderItem
                                                                  .repeat!)
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                trailing: Text(
                                                    reminderItem.category!),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(),
                            ]);
                      },
                    );
                  }),
                );

              default:
                return Container();
            }
          },
          listenWhen: (previous, current) => current is ReminderActionState,
          listener: (context, state) {
            if (state is ReminderCloseSheetActionState) {
              Navigator.of(context).pop();
              widget.reminderBloc.add(widget.event);
            }
          },
        ),
        floatingActionButton: widget.category == "All"
            ? FloatingActionButton(
                child: const Icon(Icons.add_outlined,
                    color: AppColors.kwhiteColor),
                onPressed: () {
                  BottomSheets.getBottomSheetForDateWiseTodo(
                      context: context,
                      controller: todoController,
                      timeC: timeC,
                      dateC: dateC,
                      pickedTime: timeOfDay,
                      dateTime: Dates.today,
                      formKey: formKey,
                      reminderBloc: widget.reminderBloc,
                      initialDropdownVal: categories[0],
                      initialReminderValue:
                          Models.getReminder(Reminder.sameTime),
                      initialRepeatVal: "Never",
                      onPressed: () {
                        if (formKey.currentState?.validate() == true) {
                          widget.reminderBloc.add(ReminderAddTaskClickedEvent(
                              title: todoController.text,
                              category:
                                  CategoryDropDownList.getCategoryDropDownVal(),
                              completionTime: timeC.text,
                              reminderTime: ReminderDropdown.getReminderVal(),
                              date: dateC.text,
                              repeat: RepeatDropdown.getRepeatVal()));
                        }
                      },
                      buttonLabel: "Done");
                })
            : Container(),
      ),
    );
  }
}
