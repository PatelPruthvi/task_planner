import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_planner/resources/button_demo.dart';
import 'package:task_planner/resources/components/calendar/infinite_view_calendar.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/planner_view/bloc/task_plan_bloc.dart';
import '../../../resources/components/bottom_sheets/bottom_sheet_planner.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/dates/date_time.dart';
import '../../../utils/dimensions/dimensions.dart';
import '../../../utils/fonts/font_size.dart';

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
  TextEditingController nameC = TextEditingController();
  TextEditingController startTimeC = TextEditingController();
  TextEditingController endTimeC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TimeOfDay? pickedStartTime;
  TimeOfDay? pickedEndTime;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              color: Theme.of(context).primaryColor,
              child: InfiniteCalendar(
                  homeBloc: homeBloc,
                  dateController: _dateTimelineController,
                  taskPlanBloc: taskPlanBloc)),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlocConsumer<TaskPlanBloc, TaskPlanState>(
                bloc: taskPlanBloc,
                buildWhen: (previous, current) =>
                    current is! TaskPlanActionState,
                listenWhen: (previous, current) =>
                    current is TaskPlanActionState,
                listener: (context, state) {
                  if (state is TaskPlanCloseBottomSheetState) {
                    Navigator.of(context).pop();
                    taskPlanBloc.add(TaskPlanInitialEvent());
                  }
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case TaskPlanListEmptystate:
                      return SizedBox(
                        height: Dimensions.getTabBarViewHeight(context) * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text("No Tasks Planned...",
                                    style: FontSize.getToDoItemTileTextStyle(
                                        context)))
                          ],
                        ),
                      );
                    case TaskPlanListLoadedSuccessState:
                      final successState =
                          state as TaskPlanListLoadedSuccessState;
                      return SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: successState.taskPlannerList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 0, 8.0, 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        successState
                                            .taskPlannerList[index].startTime
                                            .toString(),
                                        style:
                                            FontSize.getDescFontStyle(context)),
                                    Slidable(
                                      endActionPane: ActionPane(
                                          extentRatio: 0.2,
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onPressed: (context) {
                                                taskPlanBloc.add(
                                                    TaskPlanIthItemDeletedEvent(
                                                        taskItem: successState
                                                                .taskPlannerList[
                                                            index]));
                                              },
                                              backgroundColor:
                                                  AppColors.kredColor,
                                              foregroundColor:
                                                  AppColors.kwhiteColor,
                                              icon: Icons.delete,
                                            ),
                                          ]),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onLongPress: () {
                                            nameC.text = successState
                                                .taskPlannerList[index].title!;
                                            startTimeC.text = successState
                                                .taskPlannerList[index]
                                                .startTime!;
                                            endTimeC.text = successState
                                                .taskPlannerList[index]
                                                .endTime!;
                                            descC.text = successState
                                                .taskPlannerList[index]
                                                .description!;

                                            BottomSheets
                                                .getBottomSheetForPlanner(
                                                    context: context,
                                                    nameC: nameC,
                                                    startTimeC: startTimeC,
                                                    endTimeC: endTimeC,
                                                    descC: descC,
                                                    formKey: formKey,
                                                    pickedStartTime:
                                                        pickedStartTime,
                                                    pickedEndTime:
                                                        pickedEndTime,
                                                    taskPlanBloc: taskPlanBloc,
                                                    bottomSheetButton: Buttons
                                                        .getRectangleButton(
                                                            context, () {
                                                      if (formKey.currentState
                                                              ?.validate() ==
                                                          true) {
                                                        taskPlanBloc.add(
                                                            TaskPlanUpdateIthTaskEvent(
                                                                taskItem:
                                                                    successState
                                                                            .taskPlannerList[
                                                                        index],
                                                                taskName:
                                                                    nameC.text,
                                                                startTime:
                                                                    startTimeC
                                                                        .text,
                                                                endtime:
                                                                    endTimeC
                                                                        .text,
                                                                description:
                                                                    descC
                                                                        .text));
                                                      }
                                                    }, "Update"),
                                                    bottomSheetTitle:
                                                        "Update Task",
                                                    initialDropdownValue:
                                                        successState
                                                            .taskPlannerList[
                                                                index]
                                                            .category!,
                                                    hexColorCode: int.parse(
                                                        successState
                                                            .taskPlannerList[
                                                                index]
                                                            .hexColorCode!));
                                          },
                                          child: Container(
                                              width: Dimensions
                                                  .getTaskPlannerTileWidth(
                                                      context),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .listTileTheme
                                                    .tileColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 5,
                                                        decoration: ShapeDecoration(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            color: Color(int.parse(
                                                                successState
                                                                    .taskPlannerList[
                                                                        index]
                                                                    .hexColorCode!))),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            successState
                                                                .taskPlannerList[
                                                                    index]
                                                                .title
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Theme.of(
                                                                        context)
                                                                    .listTileTheme
                                                                    .textColor,
                                                                fontSize: FontSize
                                                                    .getAppBarTitleFontSize(
                                                                        context)),
                                                          ),
                                                          Text(
                                                            successState
                                                                .taskPlannerList[
                                                                    index]
                                                                .description
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .listTileTheme
                                                                    .textColor,
                                                                fontSize: FontSize
                                                                    .getTaskPlannerDescriptionFontSize(
                                                                        context)),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                        successState
                                            .taskPlannerList[index].endTime
                                            .toString(),
                                        style:
                                            FontSize.getDescFontStyle(context))
                                  ],
                                ));
                          },
                        ),
                      );
                    default:
                      return Container();
                  }
                }),
          ),
          // SizedBox(
          //     height: Dimensions.getTabBarViewHeight(context) * 0.95,
          //     child: TaskPlanView(homeBloc: homeBloc, taskBloc: taskPlanBloc))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_outlined, color: AppColors.kwhiteColor),
          onPressed: () {
            BottomSheets.getBottomSheetForPlanner(
                context: context,
                nameC: nameC,
                startTimeC: startTimeC,
                endTimeC: endTimeC,
                descC: descC,
                formKey: formKey,
                pickedStartTime: pickedStartTime,
                pickedEndTime: pickedEndTime,
                taskPlanBloc: taskPlanBloc,
                bottomSheetButton: Buttons.getRectangleButton(
                  context,
                  () {
                    if (formKey.currentState?.validate() == true) {
                      taskPlanBloc.add(TaskPlanAddTaskClickedEvent(
                          taskName: nameC.text,
                          startTime: startTimeC.text,
                          endtime: endTimeC.text,
                          description: descC.text));
                    }
                  },
                  "Add Task",
                ),
                bottomSheetTitle: "Add Task",
                initialDropdownValue: "None",
                hexColorCode: AppHexVals.orange);
          }),
    );
  }
}
