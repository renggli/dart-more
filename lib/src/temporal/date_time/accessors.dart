import '../../tuple/tuple_2.dart';

extension AccessorsDateTimeExtension on DateTime {
  /// Whether this is a leap year, or not.
  bool get isLeapYear => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

  /// The number of days in this year (`365` or `366`).
  int get daysInYear => isLeapYear ? 366 : 365;

  /// The number of days in this month (`28`, `29`, `30`, or `31`).
  int get daysInMonth => month == DateTime.february
      ? (isLeapYear ? 29 : 28)
      : const [31, 30, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month - 1];

  /// The number of weeks in this year (`52` or `53`).
  int get weeksInYear {
    int offset(int y) => (y + y ~/ 4 - y ~/ 100 + y ~/ 400) % 7;
    return offset(year) == 4 || offset(year - 1) == 3 ? 53 : 52;
  }

  /// The quarter `[1...4]`.
  int get quarter => 1 + (month - 1) ~/ 3;

  /// The ISO week year.
  ///
  /// This is typically the current year, unless the week is part of the
  /// previous or next year, see https://en.wikipedia.org/wiki/ISO_week_date
  /// for details.
  int get weekYear => _weekData.first;

  /// The ISO week number `[1..53]`.
  ///
  /// Check the [weekYear] to figure out what year this week is part of, see
  /// https://en.wikipedia.org/wiki/ISO_week_date for details.
  int get weekNumber => _weekData.second;

  /// Internal helper to compute the week year and number.
  Tuple2<int, int> get _weekData {
    var weekYear = year;
    var weekNumber = (dayOfYear - weekday + 10) ~/ 7;
    if (weekNumber < 1) {
      weekYear--;
      weekNumber = DateTime(weekYear).weeksInYear;
    } else if (weekNumber > weeksInYear) {
      weekYear++;
      weekNumber = 1;
    }
    return Tuple2(weekYear, weekNumber);
  }

  /// The day in the year `[1...366]`.
  int get dayOfYear {
    final ladder = isLeapYear
        ? const [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]
        : const [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return day + ladder[month - 1];
  }

  /// The hour in the day in 12-hour clock `[1...12]`.
  int get hour12 {
    var result = hour;
    if (result > 12) result -= 12;
    if (result == 0) result = 12;
    return result;
  }
}
