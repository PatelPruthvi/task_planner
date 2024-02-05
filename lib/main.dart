import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_planner/services/notification_service.dart';
import 'package:task_planner/utils/Themes/themes.dart';
import 'package:task_planner/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initNotifService();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Planner',
        themeMode: ThemeMode.system,
        darkTheme: Themes.getDarkModeTheme(context),
        theme: Themes.getLightModeTheme(context),
        home: const BottomBarView());
  }
}
