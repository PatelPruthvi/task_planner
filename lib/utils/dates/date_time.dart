import 'package:flutter/material.dart';

class Dates {
  static DateTime today = DateTime.now();
  static final startDay = DateTime.utc(2023);
  static final endDay = DateTime.utc(2030);
  static getFormattedDate(DateTime dateTime) {
    String date = dateTime.toString().substring(0, 10);
    return date;
  }

  static DateTime getDateTimeFromDateAndTime(String date, String time) {
    //date stored format is YYYY-MM-DD
    time = getconvertedTimeIn24hrFormat(time);
    final val = DateTime.parse("$date $time");
    return val;
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
