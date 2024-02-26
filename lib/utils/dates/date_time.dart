import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dates {
  static DateTime today = DateTime.now();
  static final startDay = DateTime.utc(2023);
  static final endDay = DateTime.utc(2030);
  static String getFormattedDate(DateTime dateTime) {
    String date = dateTime.toString().substring(0, 10);
    return date;
  }

  static String getDateTimeInMonthDayYearFormat(DateTime date) {
    return DateFormat("MMM d, y").format(date);
  }

  static String getDateTimeInMMMdFormat(DateTime date) {
    return DateFormat("MMM d").format(date);
  }

  static int compareTimeOfDays(String timeA, String timeB) {
    TimeOfDay a = getTimeInTimeOfDayFormat(timeA);
    TimeOfDay b = getTimeInTimeOfDayFormat(timeB);
    if (a.hour < b.hour) {
      return 1; //start time is lesser than end time
    } else if (a.hour == b.hour) {
      if (a.minute > b.minute) {
        return -1; // start time is greater than end time
      } else {
        return 1; // start time is less than end time
      }
    } else {
      return -1; // 1 states timeA is greater than time b
    }
  }

  static DateTime getDateTimeFromDateAndTime(String date, String time) {
    //date stored format is YYYY-MM-DD
    time = getconvertedTimeIn24hrFormat(time);
    DateTime val = DateTime.parse("$date $time");

    return val;
  }

  static String getDateInMdy(String date) {
    //date stored format is YYYY-MM-DD

    final val = DateTime.parse("$date 00:00");
    String dateTime = DateFormat("d MMM,yy").format(val);
    return dateTime;
  }

  static TimeOfDay getTimeInTimeOfDayFormat(String time) {
    TimeOfDay timeOfDay;
    if (time.length == 5 && time.contains(":")) {
      timeOfDay = TimeOfDay(
          hour: int.parse(time.substring(0, 2)),
          minute: int.parse(time.substring(3, 5)));
      return timeOfDay;
    } else {
      int i = 0;
      int hr = 0;
      int min = 0;

      while (time[i] != ':') {
        hr = hr * 10 + int.parse(time[i]);
        i++;
      }
      i++;
      while (time[i] != ' ') {
        min = min * 10 + int.parse(time[i]);
        i++;
      }
      i++;
      if (time[i] == 'P') {
        if (hr != 12) {
          hr = hr + 12;
        }
      } else {
        if (hr == 12) {
          hr = 0;
        }
      }
      timeOfDay = TimeOfDay(hour: hr, minute: min);
      return timeOfDay;
    }
  }

  static String getconvertedTimeIn24hrFormat(String time) {
    if (time.length == 5 && time.contains(":")) {
      time += ":00";
      return time;
    } else {
      int i = 0;
      int hr = 0;
      int min = 0;

      while (time[i] != ':') {
        hr = hr * 10 + int.parse(time[i]);
        i++;
      }
      i++;
      while (time[i] != ' ') {
        min = min * 10 + int.parse(time[i]);
        i++;
      }
      i++;
      if (time[i] == 'P') {
        if (hr != 12) {
          hr = hr + 12;
        }
      } else {
        if (hr == 12) {
          hr = 0;
        }
      }
      TimeOfDay tod = TimeOfDay(hour: hr, minute: min);
      //tod in string will print "TimeOfDay(HH:MM)"
      //here's a function to make substring right from 10th character till 15th...
      String timeIn24hr = tod.toString();
      timeIn24hr = timeIn24hr.substring(10, 15);
      //adding seconds it would be needed inorder to parse string as DateTime
      timeIn24hr += ":00";

      return timeIn24hr;
    }
  }
}
