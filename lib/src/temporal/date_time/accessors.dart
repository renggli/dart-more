extension AccessorsDateTimeExtension on DateTime {
  /// Returns `true`, if this is a leap year.
  bool get isLeapYear => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  /// The quarter `[1...4]`.
  int get quarter => 1 + (month - 1) ~/ 3;

  /// The week in the year `[1..52]`.
  ///
  /// If the return value is `0`, it means that the given date belongs to the
  /// preceding (week-based) year. If the return value is `53`, the date might
  /// actually be part of the first week of the following year.
  ///
  /// https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_from_an_ordinal_date
  int get weekOfYear => (dayOfYear - weekday + 10) ~/ 7;

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
