library more.iterable.periodic;

import 'iterate.dart' show iterate;

/// Different kinds of repeating periodic timestamps.
enum Period {
  millennially,
  centennially,
  decennially,
  yearly,
  quarterly,
  monthly,
  weekly,
  daily,
  hourly,
  minutely,
  secondly,
  millisecondly,
  microsecondly,
}

extension PeriodicalDateTime on DateTime {
  /// Creates an infinitely long [Iterable] of periodic [DateTime] timestamps.
  ///
  /// Called without arguments, the period starts at this [DateTime] and
  /// progresses in daily increments. The step size and period are configured
  /// using `step` and `period` enum of type [Period].
  ///
  /// To limit the iteration to a specific number of timestamps use
  /// [Iterable.take]; and to limit iteration to a specific end-timestamp use
  /// [Iterable.takeWhile]. For example:
  ///
  ///     // Enumerate 10 days after September 2, 2017.
  ///     DateTime(2017, DateTime.SEPTEMBER, 2).periodical().take(10)
  ///
  ///     // Enumerate the remaining days in the current year.
  ///     final today = DateTime.now();
  ///     final nextYear = DateTime(today.year + 1);
  ///     today.periodical(period: Period.daily)
  ///         .takeWhile((timestamp) => timestamp.isBefore(nextYear));
  ///
  /// Note: Due to leap seconds and daylight saving time, not all periods are
  /// of equal length. To produce an infinite sequence of timestamps that are
  /// equally spaced, simply use `iterate` and an offset instead. For example:
  ///
  ///     final offset = Duration(days: 1);
  ///     iterate(DateTime().now(), (prev) => prev.add(offset));
  ///
  Iterable<DateTime> periodical({
    int step = 1,
    Period period = Period.daily,
  }) {
    if (step == null || step == 0) {
      throw ArgumentError.value(step, 'step', 'invalid step size');
    }
    switch (period) {
      case Period.millennially:
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
      case Period.centennially:
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
      case Period.decennially:
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
      case Period.yearly:
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
      case Period.quarterly:
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
      case Period.monthly:
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
      case Period.weekly:
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
      case Period.daily:
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
      case Period.hourly:
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
      case Period.minutely:
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
      case Period.secondly:
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
      case Period.millisecondly:
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
      case Period.microsecondly:
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
    throw ArgumentError.value(period, 'period', 'unknown value');
  }
}

extension TruncateDateTime on DateTime {
  /// Truncates [DateTime] to the beginning of the provided [Period].
  DateTime truncate({
    Period period = Period.daily,
    int startWeekday = DateTime.monday,
  }) {
    switch (period) {
      case Period.millennially:
        return DateTime(
          year ~/ 1000 * 1000,
        );
      case Period.centennially:
        return DateTime(
          year ~/ 100 * 100,
        );
      case Period.decennially:
        return DateTime(
          year ~/ 10 * 10,
        );
      case Period.yearly:
        return DateTime(
          year,
        );
      case Period.quarterly:
        return DateTime(
          year,
          (month - 1) ~/ 3 * 3 + 1,
        );
      case Period.monthly:
        return DateTime(
          year,
          month,
        );
      case Period.weekly:
        RangeError.checkValueInInterval(
            startWeekday, DateTime.monday, DateTime.sunday, 'startWeekday');
        return DateTime(
          year,
          month,
          day - (7 + weekday - startWeekday) % 7,
        );
      case Period.daily:
        return DateTime(
          year,
          month,
          day,
        );
      case Period.hourly:
        return DateTime(
          year,
          month,
          day,
          hour,
        );
      case Period.minutely:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
        );
      case Period.secondly:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
        );
      case Period.millisecondly:
        return DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
        );
      case Period.microsecondly:
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
    throw ArgumentError.value(period, 'period', 'unknown value');
  }
}
