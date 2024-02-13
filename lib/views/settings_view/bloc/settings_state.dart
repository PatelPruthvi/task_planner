part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

class SettingsActionState extends SettingsState {}

class SettingsNavigateToRateActionState extends SettingsActionState {}

class SettingsNavigateToShareActionState extends SettingsActionState {}

class SettingsNavigateToPrivacyPolicyActionState extends SettingsActionState {}

class SettingsNavigateToTermsOfServiceActionState extends SettingsActionState {}

class SettingsErrorMsgActionState extends SettingsActionState {
  final String errorMsg;

  SettingsErrorMsgActionState({required this.errorMsg});
}
