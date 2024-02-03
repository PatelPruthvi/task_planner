import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/home_view/ui/home_view.dart';
import 'package:task_planner/views/task_plan_view/bloc/task_plan_bloc.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/dates/date_time.dart';
import '../../utils/dimensions/dimensions.dart';
import '../../utils/fonts/font_size.dart';
import '../../views/todo_view/bloc/to_do_bloc.dart';

DateTime now = Dates.today;

class HomeCal extends StatefulWidget {
  final HomeBloc homeBloc;
  final ToDoBloc toDoBloc;
  final TaskPlanBloc taskBloc;
  final EasyInfiniteDateTimelineController dateController;
  const HomeCal(
      {super.key,
      required this.homeBloc,
      required this.toDoBloc,
      required this.taskBloc,
      required this.dateController});

  @override
  State<HomeCal> createState() => _HomeCalState();
  static DateTime getSelectedDateTime() => now;
}

class _HomeCalState extends State<HomeCal> {
  @override
  void initState() {
    widget.homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: widget.homeBloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case HomeDateChangedState:
              final successState = state as HomeDateChangedState;
              now = state.focusedDate;
              widget.toDoBloc.add(ToDoInitialEvent());
              widget.taskBloc.add(TaskPlanInitialEvent());
              return EasyInfiniteDateTimeLine(
                controller: widget.dateController,
                onDateChange: (selectedDate) {
                  widget.homeBloc.add(
                      HomeCalendarDateTappedEvent(selectedDate: selectedDate));
                },
                headerBuilder: (context, date) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Dates.getDateTimeInMonthDayYearFormat(date),
                            style: FontSize.getMediumWhiteFontStyle(context)),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            if (Dates.getDateTimeInMMMdFormat(date) !=
                                Dates.getDateTimeInMMMdFormat(Dates.today)) {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            }
                          },
                          child: Text(
                              Dates.getDateTimeInMMMdFormat(Dates.today),
                              style: FontSize.getMediumWhiteFontStyle(context)),
                        )
                      ],
                    ),
                  );
                },
                activeColor: AppColors.mainColor,
                firstDate: Dates.startDay,
                focusDate: successState.focusedDate,
                lastDate: Dates.endDay,
                dayProps: EasyDayProps(
                    height: Dimensions.getCalendarDayHeight(context),
                    width: Dimensions.getCalendarDayWidth(context),
                    dayStructure: DayStructure.dayStrDayNum,
                    todayStyle: DayStyle(
                        dayStrStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor),
                        dayNumStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.getAppBarTitleFontSize(context),
                            color: AppColors.mainColor),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.blackColor, width: 2),
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10))),
                    activeDayStyle: DayStyle(
                        dayStrStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor),
                        dayNumStyle: TextStyle(
                            fontSize: FontSize.getAppBarTitleFontSize(context),
                            color: AppColors.whiteColor),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.screenColor),
                            color: AppColors.greyTileColor,
                            borderRadius: BorderRadius.circular(10))),
                    inactiveDayStyle: DayStyle(
                        dayStrStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        dayNumStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.getAppBarTitleFontSize(context),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.mainColor),
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10)))),
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
