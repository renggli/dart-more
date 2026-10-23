import '../time_unit.dart';

/// Extension on [DateTime] providing truncation to a [TimeUnit].
extension TruncateToDateTimeExtension on DateTime {
  /// Truncates [DateTime] to the beginning of the provided [TimeUnit].
  DateTime truncateTo(TimeUnit unit, {int startWeekday = DateTime.monday}) {
    final create = isUtc ? DateTime.utc : DateTime.new;
    switch (unit) {
      case TimeUnit.millennium:
        return create(_floorDiv(year, 1000));
      case TimeUnit.century:
        return create(_floorDiv(year, 100));
      case TimeUnit.decade:
        return create(_floorDiv(year, 10));
      case TimeUnit.year:
        return create(year);
      case TimeUnit.quarter:
        return create(year, (month - 1) ~/ 3 * 3 + 1);
      case TimeUnit.month:
        return create(year, month);
      case TimeUnit.week:
        RangeError.checkValueInInterval(
          startWeekday,
          DateTime.monday,
          DateTime.sunday,
          'startWeekday',
        );
        return create(year, month, day - (7 + weekday - startWeekday) % 7);
      case TimeUnit.day:
        return create(year, month, day);
      case TimeUnit.hour:
        return create(year, month, day, hour);
      case TimeUnit.minute:
        return create(year, month, day, hour, minute);
      case TimeUnit.second:
        return create(year, month, day, hour, minute, second);
      case TimeUnit.millisecond:
        return create(year, month, day, hour, minute, second, millisecond);
      case TimeUnit.microsecond:
        return create(
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

int _floorDiv(int value, int step) =>
    (value >= 0 ? value ~/ step : (value - step + 1) ~/ step) * step;
