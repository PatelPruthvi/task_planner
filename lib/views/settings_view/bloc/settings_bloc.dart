import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:meta/meta.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_planner/AppUrls/app_url.dart';
import 'package:url_launcher/url_launcher.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsShareButtonClickedEvent>(settingsShareButtonClickedEvent);
    on<SettingsRateButtonClickedEvent>(settingsRateButtonClickedEvent);
    on<SettingsTermsButtonClickedEvent>(settingsTermsButtonClickedEvent);
    on<SettingsPrivacyButtonClickedEvent>(settingsPrivacyButtonClickedEvent);
    on<SettingsFeedbackButtonClickedEvent>(settingsFeedbackButtonClickedEvent);
  }

  FutureOr<void> settingsFeedbackButtonClickedEvent(
      SettingsFeedbackButtonClickedEvent event,
      Emitter<SettingsState> emit) async {
    final Email email = Email(
      recipients: [AppUrls.companyEmail],
      subject: AppUrls.defaultSubject,
      body: AppUrls.defaultMailBody,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      // Handle error, if any
      emit(SettingsErrorMsgActionState(errorMsg: 'Error sending feedback...'));
    }
  }

  FutureOr<void> settingsPrivacyButtonClickedEvent(
      SettingsPrivacyButtonClickedEvent event,
      Emitter<SettingsState> emit) async {
    try {
      await launchUrl(Uri.parse(AppUrls.privacyPolicyUrl));
    } catch (e) {
      emit(SettingsErrorMsgActionState(
          errorMsg: "Unable to open privacy policy..."));
    }

    emit(SettingsNavigateToPrivacyPolicyActionState());
  }

  FutureOr<void> settingsTermsButtonClickedEvent(
      SettingsTermsButtonClickedEvent event,
      Emitter<SettingsState> emit) async {
    try {
      await launchUrl(Uri.parse(AppUrls.termsUrl));
    } catch (e) {
      emit(SettingsErrorMsgActionState(
          errorMsg: "Unable to open terms of service..."));
    }
    emit(SettingsNavigateToTermsOfServiceActionState());
  }

  FutureOr<void> settingsRateButtonClickedEvent(
      SettingsRateButtonClickedEvent event, Emitter<SettingsState> emit) async {
    try {
      if (await canLaunchUrl(Uri.parse(
          Platform.isIOS ? AppUrls.appStoreUrl : AppUrls.playStoreUrl))) {
        await launchUrl(Uri.parse(
            Platform.isIOS ? AppUrls.appStoreUrl : AppUrls.playStoreUrl));
      } else {
        emit(SettingsErrorMsgActionState(
            errorMsg: "Unable to open app ratings..."));
      }
    } catch (e) {
      emit(SettingsErrorMsgActionState(
          errorMsg: "Unable to open app ratings..."));
    }
  }

  FutureOr<void> settingsShareButtonClickedEvent(
      SettingsShareButtonClickedEvent event,
      Emitter<SettingsState> emit) async {
    try {
      await Share.share(
        'Excited to share this amazing Task Planner App: ${Platform.isIOS ? AppUrls.appStoreUrl : AppUrls.playStoreUrl}',
      );
    } catch (e) {
      // Handle sharing error, if any
      print('Error sharing: $e');
      emit(SettingsErrorMsgActionState(
          errorMsg: "Error sharing app to others..."));
    }
  }
}
