class Dates {
  static DateTime today = DateTime.now();
  static final startDay = DateTime.utc(2023);
  static final endDay = DateTime.utc(2030);
  static getFormattedDate(DateTime dateTime) {
    String date = dateTime.toString().substring(0, 10);
    return date;
  }
}
