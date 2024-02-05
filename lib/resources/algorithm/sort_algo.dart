import 'package:task_planner/models/to_do_model.dart';
import 'package:task_planner/utils/dates/date_time.dart';

import '../../models/task_planner_model.dart';

class Sorting {
  static List<TaskPlanner> sortGivenTaskPlannerList(
      List<TaskPlanner> taskPlannerList) {
    taskPlannerList.sort((a, b) {
      double timevalA = Sorting.timeConvertIntoDouble(a.startTime!);
      double timevalB = Sorting.timeConvertIntoDouble(b.startTime!);
      return timevalA.compareTo(timevalB);
    });
    return taskPlannerList;
  }

  static List<ToDo> sortGivenTodoListAccordtingToTime(List<ToDo> toDoList) {
    toDoList.sort((a, b) {
      double timevalA = Sorting.timeConvertIntoDouble(a.completionTime!);
      double timevalB = Sorting.timeConvertIntoDouble(b.completionTime!);
      return timevalA.compareTo(timevalB);
    });
    return toDoList;
  }

  static List<ToDo> sortGivenTodoListAccordtingToDateTime(List<ToDo> toDoList) {
    toDoList.sort((a, b) {
      DateTime aDate =
          Dates.getDateTimeFromDateAndTime(a.date!, a.completionTime!);
      DateTime bDate =
          Dates.getDateTimeFromDateAndTime(b.date!, b.completionTime!);

      return aDate.compareTo(bDate);
    });
    return toDoList;
  }

  static double timeConvertIntoDouble(String a) {
    int i = 0;
    int hr = 0;
    int min = 0;
    double timeVal;
    if (a.length == 5) {
      hr = int.parse(a.substring(0, 2));
      min = int.parse(a.substring(3, 2));
      timeVal = hr + min / 60;
      return timeVal;
    } else {
      while (a[i] != ':') {
        hr = hr * 10 + int.parse(a[i]);
        i++;
      }
      i++;
      while (a[i] != ' ') {
        min = min * 10 + int.parse(a[i]);
        i++;
      }
      i++;
      if (a[i] == 'P') {
        if (hr != 12) {
          hr = hr + 12;
        }
      } else {
        if (hr == 12) {
          hr = 0;
        }
      }
      timeVal = hr + min / 60;
      return timeVal;
    }
  }
}
