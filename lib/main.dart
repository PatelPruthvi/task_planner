// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:task_planner/services/notification_service.dart';
import 'package:task_planner/utils/Themes/themes.dart';
import 'package:task_planner/views/login_view/ui/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initNotifService();
  tz.initializeTimeZones();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: Themes.getLightModeTheme(context),
      dark: Themes.getDarkModeTheme(context),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Planner',
          darkTheme: dark,
          theme: light,
          home: const LoginView(),
        );
      },
    );
  }
}
