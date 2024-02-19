class AppExceptions implements Exception {
  final String? _message;

  const AppExceptions([
    this._message,
  ]);

  @override
  String toString() => _message!;
}

class ImpossibleReminderTimeException extends AppExceptions {
  ImpossibleReminderTimeException([String? message])
      : super("Can not set reminder for that time");
}

class InternetNotConnectedException extends AppExceptions {
  InternetNotConnectedException([String? message])
      : super("Internet not connected...");
}
