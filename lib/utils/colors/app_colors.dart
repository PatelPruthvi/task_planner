import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  static const mainColor = Color(0xFF075e54);
  static const calendarTileColor = Color.fromARGB(255, 1, 59, 52);
  static const screenColor = Color.fromARGB(255, 231, 236, 236);
  static const whiteColor = Colors.white;
  static Color redColor = Colors.red.shade600;
  static const blackColor = Colors.black;
  static Color getRandomColorForTaskPlanner() {
    var generatedColor = Random().nextInt(Colors.primaries.length);
    return Colors.primaries[generatedColor];
  }
}

List<int> appHexColorCodes = [
  0xFFFF0000,
  0xFF8F00FF,
  0xFFFC0FC0,
  0xFFFFA500,
  0xFF008000,
  0xFF00A36C,
  0xFFFFFF00,
  0xFF964B00,
  0xFF0000FF,
  0xFF808080,
  0xFF00BFA6,
  0xFF00B0FF
];

class AppHexVals {
  static const int red = 0xFFFF0000;
  static const int violet = 0xFF8F00FF;
  static const int pink = 0xFFFC0FC0;
  static const int orange = 0xFFFFA500;
  static const int hunterGreen = 0xFF008000;
  static const int jadeGreen = 0xFF00A36C;
  static const int yellow = 0xFFFFFF00;
  static const int brown = 0xFF964B00;
  static const int blue = 0xFF0000FF;
  static const int gray = 0xFF808080;
  static const int teal = 0xFF00BFA6;
  static const int lightBlue = 0xFF00B0FF;
}
