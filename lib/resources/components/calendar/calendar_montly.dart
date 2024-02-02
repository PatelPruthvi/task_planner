import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_planner/views/home_view/bloc/home_bloc.dart';
import 'package:task_planner/views/task_plan_view/bloc/task_plan_bloc.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/dates/date_time.dart';
import '../../../utils/dimensions/dimensions.dart';
import '../../../utils/fonts/font_size.dart';
import '../../../views/todo_view/bloc/to_do_bloc.dart';

DateTime now = Dates.today;

class CalendarView extends StatefulWidget {
  final HomeBloc homeBloc;
  final ToDoBloc toDoBloc;
  final TaskPlanBloc taskBloc;
  const CalendarView(
      {super.key,
      required this.homeBloc,
      required this.toDoBloc,
      required this.taskBloc});

  @override
  State<CalendarView> createState() => _CalendarViewState();
  static DateTime getSelectedDateTime() => now;
}

class _CalendarViewState extends State<CalendarView> {
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
              now = successState.focusedDate;
              widget.toDoBloc.add(ToDoInitialEvent());
              widget.taskBloc.add(TaskPlanInitialEvent());
              return EasyDateTimeLine(
                onDateChange: (selectedDate) {
                  now = selectedDate;
                  widget.homeBloc.add(
                      HomeCalendarDateTappedEvent(selectedDate: selectedDate));
                },
                activeColor: AppColors.mainColor,
                initialDate: Dates.today,
                headerProps: EasyHeaderProps(
                    monthPickerType: MonthPickerType.switcher,
                    dateFormatter: const DateFormatter.custom("d MMM y"),
                    monthStyle: FontSize.getMediumWhiteFontStyle(context),
                    selectedDateStyle:
                        FontSize.getMediumWhiteFontStyle(context)),
                dayProps: EasyDayProps(
                    height: Dimensions.getCalendarDayHeight(context),
                    width: Dimensions.getCalendarDayWidth(context),
                    dayStructure: DayStructure.dayStrDayNum,
                    todayStyle: DayStyle(
                        dayStrStyle: TextStyle(
                            fontFamily: GoogleFonts.varelaRound().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: AppColors.redColor),
                        dayNumStyle: TextStyle(
                            fontFamily: GoogleFonts.varelaRound().fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.getAppBarTitleFontSize(context),
                            color: AppColors.redColor),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.redColor),
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10))),
                    activeDayStyle: DayStyle(
                        dayStrStyle: TextStyle(
                            fontFamily: GoogleFonts.varelaRound().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor),
                        dayNumStyle: TextStyle(
                            fontFamily: GoogleFonts.varelaRound().fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.getAppBarTitleFontSize(context),
                            color: AppColors.whiteColor),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.screenColor),
                            color: AppColors.calendarTileColor,
                            borderRadius: BorderRadius.circular(10))),
                    inactiveDayStyle: DayStyle(
                        dayStrStyle: TextStyle(
                            fontFamily: GoogleFonts.varelaRound().fontFamily,
                            fontWeight: FontWeight.bold),
                        dayNumStyle: TextStyle(
                          fontFamily: GoogleFonts.varelaRound().fontFamily,
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
