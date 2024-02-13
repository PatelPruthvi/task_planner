import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/resources/components/buttons/settings_page_button.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/views/settings_view/bloc/settings_bloc.dart';

import '../../../utils/fonts/font_size.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingsBloc settingBloc = SettingsBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              "images/task_planner_cream.png",
              width: Dimensions.getScreenWidth(context) * 0.4,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: SingleChildScrollView(
          child: BlocListener<SettingsBloc, SettingsState>(
            bloc: settingBloc,
            listener: (context, state) {
              if (state is SettingsNavigateToRateActionState) {
              } else if (state is SettingsNavigateToShareActionState) {
              } else if (state is SettingsNavigateToPrivacyPolicyActionState) {
              } else if (state is SettingsNavigateToPrivacyPolicyActionState) {}
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).listTileTheme.tileColor,
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // const Icon(Icons.sunny),
                      // const SizedBox(width: 10),
                      const Icon(Icons.dark_mode),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Dark Theme",
                          style: TextStyle(
                              fontSize: FontSize.getMediumFontSize(context),
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).listTileTheme.textColor),
                        ),
                      ),
                      Switch.adaptive(
                        value: AdaptiveTheme.of(context).mode.isDark,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          if (value) {
                            AdaptiveTheme.of(context).setDark();
                          } else {
                            AdaptiveTheme.of(context).setLight();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SettingsPageButton(
                    text: "Rate App", press: () {}, icon: Icons.star),
                SettingsPageButton(
                    text: "Share App", press: () {}, icon: Icons.share),
                SettingsPageButton(
                    text: "Send us a Feedback", press: () {}, icon: Icons.mail),
                SettingsPageButton(
                    text: "Privacy Policy",
                    press: () {},
                    icon: Icons.back_hand),
                SettingsPageButton(
                    text: "Terms of Service",
                    press: () {},
                    icon: Icons.article_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
