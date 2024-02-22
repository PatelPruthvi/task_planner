import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_planner/resources/components/buttons/settings_page_button.dart';

import 'package:task_planner/utils/widgets/utils.dart';
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
    bool isDark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Utils.getAppLogoForAppBar(context),
                const SizedBox(width: 10),
                const Text("Settings")
              ],
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
              } else if (state is SettingsNavigateToPrivacyPolicyActionState) {
              } else if (state is SettingsErrorMsgActionState) {
                Utils.flushBarErrorMsg(state.errorMsg, context);
              }
            },
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      isDark = !isDark;
                      if (isDark) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                    child: Container(
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
                            child: Text("Dark Theme",
                                style: FontDecors.getToDoItemTileTextStyle(
                                    context)),
                          ),
                          Switch.adaptive(
                            value: isDark,
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
                  ),
                ),
                SettingsPageButton(
                    text: "Rate App",
                    press: () {
                      settingBloc.add(SettingsRateButtonClickedEvent());
                    },
                    icon: Icons.star),
                SettingsPageButton(
                    text: "Share App",
                    press: () {
                      settingBloc.add(SettingsShareButtonClickedEvent());
                    },
                    icon: Icons.share),
                SettingsPageButton(
                    text: "Send us a Feedback",
                    press: () {
                      settingBloc.add(SettingsFeedbackButtonClickedEvent());
                    },
                    icon: Icons.mail),
                SettingsPageButton(
                    text: "Privacy Policy",
                    press: () {
                      settingBloc.add(SettingsPrivacyButtonClickedEvent());
                    },
                    icon: Icons.back_hand),
                SettingsPageButton(
                    text: "Terms of Service",
                    press: () {
                      settingBloc.add(SettingsTermsButtonClickedEvent());
                    },
                    icon: Icons.article_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
