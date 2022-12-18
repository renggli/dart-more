import '../../../temporal.dart';

/// Different kinds of repeating periodic timestamps.
enum Period {
  @Deprecated('Instead use `TimeUnit.millennium`.')
  millennially(TimeUnit.millennium),
  @Deprecated('Instead use `TimeUnit.century`.')
  centennially(TimeUnit.century),
  @Deprecated('Instead use `TimeUnit.decade`.')
  decennially(TimeUnit.decade),
  @Deprecated('Instead use `TimeUnit.year`.')
  yearly(TimeUnit.year),
  @Deprecated('Instead use `TimeUnit.quarter`.')
  quarterly(TimeUnit.quarter),
  @Deprecated('Instead use `TimeUnit.month`.')
  monthly(TimeUnit.month),
  @Deprecated('Instead use `TimeUnit.week`.')
  weekly(TimeUnit.week),
  @Deprecated('Instead use `TimeUnit.day`.')
  daily(TimeUnit.day),
  @Deprecated('Instead use `TimeUnit.hour`.')
  hourly(TimeUnit.hour),
  @Deprecated('Instead use `TimeUnit.minute`.')
  minutely(TimeUnit.minute),
  @Deprecated('Instead use `TimeUnit.second`.')
  secondly(TimeUnit.second),
  @Deprecated('Instead use `TimeUnit.millisecond`.')
  millisecondly(TimeUnit.millisecond),
  @Deprecated('Instead use `TimeUnit.microsecond`.')
  microsecondly(TimeUnit.microsecond);

  const Period(this.timeUnit);

  final TimeUnit timeUnit;
}

extension PeriodicalExtension on DateTime {
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
  @Deprecated('Instead use `PeriodicalDateTimeExtension.periodical`')
  Iterable<DateTime> periodical({
    int step = 1,
    Period period = Period.daily,
  }) =>
      PeriodicalDateTimeExtension(this).periodical(period.timeUnit, step: step);
}

extension TruncateExtension on DateTime {
  /// Truncates [DateTime] to the beginning of the provided [Period].
  @Deprecated('Instead use `TruncateToDateTimeExtension.truncateTo`')
  DateTime truncate({
    Period period = Period.daily,
    int startWeekday = DateTime.monday,
  }) =>
      TruncateToDateTimeExtension(this)
          .truncateTo(period.timeUnit, startWeekday: startWeekday);
}
