import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/to_do_view/bloc/to_do_bloc.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/dates/date_time.dart';
import '../../../utils/dimensions/dimensions.dart';
import '../../../utils/fonts/font_size.dart';
import '../../../views/planner_view/bloc/task_plan_bloc.dart';

DateTime now = Dates.today;

class InfiniteCalendar extends StatefulWidget {
  final HomeBloc homeBloc;
  final EasyInfiniteDateTimelineController dateController;
  final ToDoBloc? toDoBloc;
  final TaskPlanBloc? taskPlanBloc;
  const InfiniteCalendar(
      {super.key,
      required this.homeBloc,
      required this.dateController,
      this.toDoBloc,
      this.taskPlanBloc});

  @override
  State<InfiniteCalendar> createState() => _InfiniteCalendarState();
  static DateTime getSelectedDateTime() => now;
}

class _InfiniteCalendarState extends State<InfiniteCalendar> {
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

              widget.toDoBloc?.add(ToDoInitialEvent());

              widget.taskPlanBloc?.add(TaskPlanInitialEvent());

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
                            widget.dateController.animateToDate(Dates.today);
                            widget.homeBloc.add(HomeCalendarDateTappedEvent(
                                selectedDate: Dates.today));
                          },
                          child: Text(
                              Dates.getDateTimeInMMMdFormat(Dates.today),
                              style: FontSize.getMediumWhiteFontStyle(context)),
                        )
                      ],
                    ),
                  );
                },
                activeColor: Theme.of(context).primaryColor,
                firstDate: Dates.startDay,
                focusDate: successState.focusedDate,
                lastDate: Dates.endDay,
                dayProps: EasyDayProps(
                    height: Dimensions.getCalendarDayHeight(context),
                    width: Dimensions.getCalendarDayWidth(context),
                    dayStructure: DayStructure.dayStrDayNum,
                    todayStyle: DayStyle(
                        dayStrStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.kwhiteColor
                                : AppColors.kredColor),
                        dayNumStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.getAppBarTitleFontSize(context),
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.kwhiteColor
                                : AppColors.kredColor),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.kwhiteColor
                                    : AppColors.kredColor),
                            color: Theme.of(context).splashColor,
                            borderRadius: BorderRadius.circular(10))),
                    activeDayStyle: DayStyle(
                        dayStrStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor),
                        dayNumStyle:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: FontSize.getAppBarTitleFontSize(context), color: Theme.of(context).canvasColor),
                        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).canvasColor, width: 2), color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(10))),
                    inactiveDayStyle: DayStyle(dayStrStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.kblackColor), dayNumStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: FontSize.getAppBarTitleFontSize(context), color: AppColors.kblackColor), decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor), color: Theme.of(context).splashColor, borderRadius: BorderRadius.circular(10)))),
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
