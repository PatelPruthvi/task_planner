import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_planner/models/reminder_model.dart';
import 'package:task_planner/utils/colors/app_colors.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
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
  FocusNode titleFocusNode = FocusNode();

  @override
  void dispose() {
    titleFocusNode.dispose();
    super.dispose();
  }

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
                    style: FontDecors.getToDoItemTileTextStyle(context),
                  ),
                );
              case ReminderLoadedSuccessState:
                final successState = state as ReminderLoadedSuccessState;
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: StatefulBuilder(builder: (context, setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: successState.reminderItems.length,
                      addRepaintBoundaries: true,
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
                                      successState.isVisible[index] =
                                          !successState.isVisible[index];
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          Dates.getDateInMdy(successState
                                              .reminderItems[index][0].date!),
                                          style: FontDecors.getDescFontStyle(
                                              context)),
                                      Icon(successState.isVisible[index]
                                          ? Icons.keyboard_arrow_down_outlined
                                          : Icons.keyboard_arrow_up_outlined),
                                    ],
                                  ),
                                ),
                              ),
                              successState.isVisible[index]
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
                                            key: UniqueKey(),
                                            endActionPane: ActionPane(
                                                extentRatio: 0.2,
                                                motion: const ScrollMotion(),
                                                //drag to delete functionality
                                                // dismissible: DismissiblePane(
                                                //     onDismissed: () {
                                                //   // remind.add(ToDoIthItemDeletedButtonClickedEvent(
                                                //   //     reminderItem: reminderItems[index]));
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
                                                  titleFocusNode:
                                                      titleFocusNode,
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
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 7, 7, 7),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                          side: BorderSide(
                                                            color: Theme.of(
                                                                    context)
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
                                                            if (reminderItem
                                                                    .repeat ==
                                                                "Never") {
                                                              widget
                                                                  .reminderBloc
                                                                  .add(ReminderIthItemCheckBoxClickedEvent(
                                                                      reminderItem:
                                                                          reminderItem,
                                                                      category:
                                                                          widget
                                                                              .category));
                                                            } else {
                                                              DialogBoxes.getAlertDialogForRepeatTaskCompletion(
                                                                  context:
                                                                      context,
                                                                  reminderItem:
                                                                      reminderItem,
                                                                  reminderBloc:
                                                                      widget
                                                                          .reminderBloc,
                                                                  category: widget
                                                                      .category);
                                                            }
                                                          }),
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 8, 0, 8),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: Dimensions.getSmallerSizedBox(
                                                                            context)
                                                                        .width!),
                                                                child: Text(
                                                                    reminderItem
                                                                        .title!,
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: FontDecors
                                                                        .getReminderItemTitleTextStyle(
                                                                            context)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 4, 0, 8),
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
                                                                        const Icon(
                                                                            Icons.timer_outlined),
                                                                        Text(
                                                                          reminderItem
                                                                              .completionTime!,
                                                                          style:
                                                                              FontDecors.getDescFontStyle(context),
                                                                        )
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
                                                                        Text(
                                                                          reminderItem
                                                                              .repeat!,
                                                                          style:
                                                                              FontDecors.getDescFontStyle(context),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ],
                                                      )),
                                                      Container(
                                                          width: 2,
                                                          color: AppColors
                                                              .kscreenColor),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          RotatedBox(
                                                            quarterTurns: -1,
                                                            child: Text(
                                                              reminderItem
                                                                  .category!,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                      titleFocusNode: titleFocusNode,
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
