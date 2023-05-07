import '../../../temporal.dart';

/// Different kinds of repeating periodic timestamps.
enum Period {
  @Deprecated('Use `TimeUnit.millennium` instead')
  millennially(TimeUnit.millennium),
  @Deprecated('Use `TimeUnit.century` instead')
  centennially(TimeUnit.century),
  @Deprecated('Use `TimeUnit.decade` instead')
  decennially(TimeUnit.decade),
  @Deprecated('Use `TimeUnit.year` instead')
  yearly(TimeUnit.year),
  @Deprecated('Use `TimeUnit.quarter` instead')
  quarterly(TimeUnit.quarter),
  @Deprecated('Use `TimeUnit.month` instead')
  monthly(TimeUnit.month),
  @Deprecated('Use `TimeUnit.week` instead')
  weekly(TimeUnit.week),
  @Deprecated('Use `TimeUnit.day` instead')
  daily(TimeUnit.day),
  @Deprecated('Use `TimeUnit.hour` instead')
  hourly(TimeUnit.hour),
  @Deprecated('Use `TimeUnit.minute` instead')
  minutely(TimeUnit.minute),
  @Deprecated('Use `TimeUnit.second` instead')
  secondly(TimeUnit.second),
  @Deprecated('Use `TimeUnit.millisecond` instead')
  millisecondly(TimeUnit.millisecond),
  @Deprecated('Use `TimeUnit.microsecond` instead')
  microsecondly(TimeUnit.microsecond);

  const Period(this.timeUnit);

  final TimeUnit timeUnit;
}

extension PeriodicalIterableExtension on DateTime {
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
  @Deprecated('Use `PeriodicalDateTimeExtension.periodical` instead')
  Iterable<DateTime> periodical({
    int step = 1,
    Period period = Period.daily,
  }) =>
      PeriodicalDateTimeExtension(this).periodical(period.timeUnit, step: step);
}

extension TruncateIterableExtension on DateTime {
  /// Truncates [DateTime] to the beginning of the provided [Period].
  @Deprecated('Use `TruncateToDateTimeExtension.truncateTo` instead')
  DateTime truncate({
    Period period = Period.daily,
    int startWeekday = DateTime.monday,
  }) =>
      TruncateToDateTimeExtension(this)
          .truncateTo(period.timeUnit, startWeekday: startWeekday);
}
