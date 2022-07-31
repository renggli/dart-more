import '../time_unit.dart';

extension TruncateToDateTimeExtension on DateTime {
  /// Truncates [DateTime] to the beginning of the provided [TimeUnit].
  DateTime truncateTo(TimeUnit unit, {int startWeekday = DateTime.monday}) {
    switch (unit) {
      case TimeUnit.millennium:
        return DateTime(
          year ~/ 1000 * 1000,
        );
      case TimeUnit.century:
        return DateTime(
          year ~/ 100 * 100,
        );
      case TimeUnit.decade:
        return DateTime(
          year ~/ 10 * 10,
        );
      case TimeUnit.year:
        return DateTime(
          year,
        );
      case TimeUnit.quarter:
        return DateTime(
          year,
          (month - 1) ~/ 3 * 3 + 1,
        );
      case TimeUnit.month:
        return DateTime(
          year,
          month,
        );
      case TimeUnit.week:
        RangeError.checkValueInInterval(
            startWeekday, DateTime.monday, DateTime.sunday, 'startWeekday');
        return DateTime(
          year,
          month,
          day - (7 + weekday - startWeekday) % 7,
        );
      case TimeUnit.day:
        return DateTime(
          year,
          month,
          day,
        );
      case TimeUnit.hour:
        return DateTime(
          year,
          month,
          day,
          hour,
        );
      case TimeUnit.minute:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
        );
      case TimeUnit.second:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
        );
      case TimeUnit.millisecond:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
        );
      case TimeUnit.microsecond:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );
    }
  }
}
