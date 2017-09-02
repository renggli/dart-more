library more.iterable.periodic;

import 'package:more/src/iterable/iterate.dart' show iterate;

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

/// Creates an infinitely long [Iterable] of periodic [DateTime] timestamps.
///
/// Called without arguments, the period starts now and progresses in daily
/// increments.
///
/// The initial timestamp can be configured using the `start` parameter; and the
/// period using `step` and the `period` enum of type [Period].
///
/// To limit the iteration to a specific number of timestamps use [Iterable.take];
/// and to limit iteration to a specific end-timestamp use [Iterable.takeWhile].
/// For example:
///
///     // Enumerate 10 days after September 2, 2017.
///     periodical(start: new DateTime(2017, DateTime.SEPTEMBER, 2))
///         .take(10)
///
///     // Enumerate the remaining days in the current year.
///     var nextYear = new DateTime(new DateTime.now().year + 1);
///     periodical(period: Period.daily)
///         .takeWhile((timestamp) => timestamp.isBefore(nextYear));
///
/// Note: Due to leap seconds and daylight saving time, not all periods are
/// of equal length. To produce an infinite sequence of timestamps that are
/// equally spaced, simply use `iterate` and an offset instead. For example:
///
///     var offset = new Duration(days: 1);
///     iterate(new DateTime().now(), (prev) => prev.add(offset));
///
Iterable<DateTime> periodical({
  DateTime start,
  int step: 1,
  Period period: Period.daily,
}) {
  start ??= new DateTime.now();
  if (step == null || step == 0) {
    throw new ArgumentError.value(step, 'step', 'invalid step size');
  }
  switch (period) {
    case Period.millennially:
      return iterate(
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
          start,
          (prev) => new DateTime(
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
  throw new ArgumentError.value(period, 'period', 'unknown value');
}

/// Helper that truncates a [DateTime] `timestamp` to the beginning of the
/// specified period.
///
/// Truncates the `timestamp` to the beginning of the provided Period.
DateTime truncateToPeriod(
  DateTime timestamp, {
  Period period: Period.daily,
  int startWeekday: DateTime.MONDAY,
}) {
  if (timestamp == null) {
    throw new ArgumentError.notNull('timestamp');
  }
  switch (period) {
    case Period.millennially:
      return new DateTime(
        timestamp.year ~/ 1000 * 1000,
      );
    case Period.centennially:
      return new DateTime(
        timestamp.year ~/ 100 * 100,
      );
    case Period.decennially:
      return new DateTime(
        timestamp.year ~/ 10 * 10,
      );
    case Period.yearly:
      return new DateTime(
        timestamp.year,
      );
    case Period.quarterly:
      return new DateTime(
        timestamp.year,
        (timestamp.month - 1) ~/ 3 * 3 + 1,
      );
    case Period.monthly:
      return new DateTime(
        timestamp.year,
        timestamp.month,
      );
    case Period.weekly:
      RangeError.checkValueInInterval(
          startWeekday, DateTime.MONDAY, DateTime.SUNDAY, 'startWeekday');
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day - (7 + timestamp.weekday - startWeekday) % 7,
      );
    case Period.daily:
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
      );
    case Period.hourly:
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
      );
    case Period.minutely:
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute,
      );
    case Period.secondly:
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute,
        timestamp.second,
      );
    case Period.millisecondly:
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute,
        timestamp.second,
        timestamp.millisecond,
      );
    case Period.microsecondly:
      return new DateTime(
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute,
        timestamp.second,
        timestamp.millisecond,
        timestamp.microsecond,
      );
  }
  throw new ArgumentError.value(period, 'period', 'unknown value');
}
