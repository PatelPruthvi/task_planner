// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_planner/resources/components/bottom_sheets/bottom_sheet_planner.dart';
import 'package:task_planner/utils/dates/date_time.dart';
import 'package:task_planner/utils/fonts/font_size.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';

import '../../../resources/button_demo.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/dimensions/dimensions.dart';
import '../bloc/task_plan_bloc.dart';

DateTime dateTime = Dates.startDay;

class TaskPlanView extends StatefulWidget {
  final HomeBloc homeBloc;
  final TaskPlanBloc taskBloc;
  const TaskPlanView({
    Key? key,
    required this.homeBloc,
    required this.taskBloc,
  }) : super(key: key);

  @override
  State<TaskPlanView> createState() => _TaskPlanViewState();
}

class _TaskPlanViewState extends State<TaskPlanView> {
  TextEditingController nameC = TextEditingController();
  TextEditingController startTimeC = TextEditingController();
  TextEditingController endTimeC = TextEditingController();
  TextEditingController descC = TextEditingController();
  TimeOfDay? pickedStartTime;
  TimeOfDay? pickedEndTime;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.taskBloc.add(TaskPlanInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocConsumer<TaskPlanBloc, TaskPlanState>(
            bloc: widget.taskBloc,
            buildWhen: (previous, current) => current is! TaskPlanActionState,
            listenWhen: (previous, current) => current is TaskPlanActionState,
            listener: (context, state) {
              if (state is TaskPlanCloseBottomSheetState) {
                Navigator.of(context).pop();
                widget.taskBloc.add(TaskPlanInitialEvent());
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case TaskPlanListEmptystate:
                  return SizedBox(
                    height: Dimensions.getTabBarViewHeight(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text("No Tasks Planned...",
                                style:
                                    FontSize.getToDoItemTileTextStyle(context)))
                      ],
                    ),
                  );
                case TaskPlanListLoadedSuccessState:
                  final successState = state as TaskPlanListLoadedSuccessState;
                  return SizedBox(
                    height: Dimensions.getTodoListViewHeight(context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: successState.taskPlannerList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8.0, 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    successState
                                        .taskPlannerList[index].startTime
                                        .toString(),
                                    style: FontSize.getDescFontStyle(context)),
                                Slidable(
                                  endActionPane: ActionPane(
                                      extentRatio: 0.2,
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onPressed: (context) {
                                            widget.taskBloc.add(
                                                TaskPlanIthItemDeletedEvent(
                                                    taskItem: successState
                                                            .taskPlannerList[
                                                        index]));
                                          },
                                          backgroundColor: AppColors.redColor,
                                          foregroundColor: AppColors.whiteColor,
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
                                            .taskPlannerList[index].startTime!;
                                        endTimeC.text = successState
                                            .taskPlannerList[index].endTime!;
                                        descC.text = successState
                                            .taskPlannerList[index]
                                            .description!;

                                        BottomSheets.getBottomSheetForPlanner(
                                            context,
                                            nameC,
                                            startTimeC,
                                            endTimeC,
                                            descC,
                                            formKey,
                                            pickedStartTime,
                                            pickedEndTime,
                                            widget.taskBloc,
                                            Buttons.getRectangleButton(context,
                                                () {
                                              if (formKey.currentState
                                                      ?.validate() ==
                                                  true) {
                                                widget.taskBloc.add(
                                                    TaskPlanUpdateIthTaskEvent(
                                                        taskItem: successState
                                                                .taskPlannerList[
                                                            index],
                                                        taskName: nameC.text,
                                                        startTime:
                                                            startTimeC.text,
                                                        endtime: endTimeC.text,
                                                        description:
                                                            descC.text));
                                              }
                                            }, "Update"),
                                            "Update Task",
                                            successState.taskPlannerList[index]
                                                .category!,
                                            int.parse(successState
                                                .taskPlannerList[index]
                                                .hexColorCode!));
                                      },
                                      child: Container(
                                          width: Dimensions
                                              .getTaskPlannerTileWidth(context),
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.mainColor),
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                                FontWeight.bold,
                                                            fontFamily: GoogleFonts
                                                                    .varelaRound()
                                                                .fontFamily,
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
                                                            fontFamily: GoogleFonts
                                                                    .varelaRound()
                                                                .fontFamily,
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
                                    successState.taskPlannerList[index].endTime
                                        .toString(),
                                    style: FontSize.getDescFontStyle(context))
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_outlined, color: AppColors.whiteColor),
          onPressed: () {
            BottomSheets.getBottomSheetForPlanner(
                context,
                nameC,
                startTimeC,
                endTimeC,
                descC,
                formKey,
                pickedStartTime,
                pickedEndTime,
                widget.taskBloc,
                Buttons.getRectangleButton(
                  context,
                  () {
                    if (formKey.currentState?.validate() == true) {
                      widget.taskBloc.add(TaskPlanAddTaskClickedEvent(
                          taskName: nameC.text,
                          startTime: startTimeC.text,
                          endtime: endTimeC.text,
                          description: descC.text));
                    }
                  },
                  "Add Task",
                ),
                "Add Task",
                "None",
                AppHexVals.orange);
          }),
    );
  }
}
