part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class SettingsRateButtonClickedEvent extends SettingsEvent {}

class SettingsShareButtonClickedEvent extends SettingsEvent {}

class SettingsFeedbackButtonClickedEvent extends SettingsEvent {}

class SettingsPrivacyButtonClickedEvent extends SettingsEvent {}

class SettingsTermsButtonClickedEvent extends SettingsEvent {}
