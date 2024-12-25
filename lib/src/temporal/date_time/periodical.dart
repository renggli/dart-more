import '../../../collection.dart';
import '../time_unit.dart';

extension PeriodicalDateTimeExtension on DateTime {
  /// Creates an infinitely long [Iterable] of periodic [DateTime] timestamps
  /// starting at this [DateTime].
  ///
  /// The step size is configured using a required [TimeUnit] [unit], and an
  /// optional [step] size that defaults to `1`.
  ///
  /// To limit the iteration to a specific number of timestamps use
  /// [Iterable.take]; and to limit iteration to a specific end-timestamp use
  /// [Iterable.takeWhile]. For example:
  ///
  /// ```dart
  /// // Enumerate 10 days after September 2, 2017.
  /// DateTime(2017, DateTime.SEPTEMBER, 2).periodical().take(10)
  /// ```
  ///
  /// ```dart
  /// // Enumerate the remaining days in the current year.
  /// final today = DateTime.now();
  /// final nextYear = DateTime(today.year + 1);
  /// today.periodical(period: Period.daily)
  ///     .takeWhile((timestamp) => timestamp.isBefore(nextYear));
  /// ```
  ///
  /// Note: Due to leap seconds and daylight saving time, not all periods are
  /// of equal length. To produce an infinite sequence of timestamps that are
  /// equally spaced, simply use `iterate` and an offset instead. For example:
  ///
  /// ```dart
  /// final offset = Duration(days: 1);
  /// iterate(DateTime().now(), (prev) => prev.add(offset));
  /// ```
  Iterable<DateTime> periodical(TimeUnit unit, {int step = 1}) {
    if (step == 0) {
      throw ArgumentError.value(step, 'step', 'Expected non-zero step size');
    }
    switch (unit) {
      case TimeUnit.millennium:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year + 1000 * step,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.century:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year + 100 * step,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.decade:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year + 10 * step,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.year:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year + step,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.quarter:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month + 3 * step,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.month:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month + step,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.week:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day + 7 * step,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.day:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day + step,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.hour:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day,
                  prev.hour + step,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.minute:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute + step,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.second:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second + step,
                  prev.millisecond,
                  prev.microsecond,
                ));
      case TimeUnit.millisecond:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond + step,
                  prev.microsecond,
                ));
      case TimeUnit.microsecond:
        return iterate(
            this,
            (prev) => DateTime(
                  prev.year,
                  prev.month,
                  prev.day,
                  prev.hour,
                  prev.minute,
                  prev.second,
                  prev.millisecond,
                  prev.microsecond + step,
                ));
    }
  }
}
