extension DateTimeExtension on DateTime {
  /// The quarter `[1...4]`.
  int get quarter => 1 + (month - 1) ~/ 3;

  /// The day in the year `[1...365]`.
  int get dayOfYear => 1 + difference(DateTime(year)).inDays;

  /// The hour in the day in 12-hour clock `[1...12]`.
  int get hour12 {
    var result = hour;
    if (result > 12) result -= 12;
    if (result == 0) result = 12;
    return result;
  }
}
