import 'time_unit.dart';

/// Casual conversion scheme from different [TimeUnit]s to microseconds.
///
/// This naive conversion assumes that a day has 30 days and a year has
/// 365 days. While this is the default for all operations, it is not typically
/// correct or event consistent.
const Map<TimeUnit, int> casualConversion = {
  TimeUnit.microsecond: 1,
  TimeUnit.millisecond: Duration.microsecondsPerMillisecond,
  TimeUnit.second: Duration.microsecondsPerSecond,
  TimeUnit.minute: Duration.microsecondsPerMinute,
  TimeUnit.hour: Duration.microsecondsPerHour,
  TimeUnit.day: Duration.microsecondsPerDay,
  TimeUnit.week: 7 * Duration.microsecondsPerDay,
  TimeUnit.month: 30 * Duration.microsecondsPerDay,
  TimeUnit.quarter: 3 * 30 * Duration.microsecondsPerDay,
  TimeUnit.year: 365 * Duration.microsecondsPerDay,
  TimeUnit.decade: 10 * 365 * Duration.microsecondsPerDay,
  TimeUnit.century: 100 * 365 * Duration.microsecondsPerDay,
  TimeUnit.millennium: 1000 * 365 * Duration.microsecondsPerDay,
};

/// Accurate conversion scheme from different [TimeUnit]s to microseconds.
///
/// This conversion scheme provides a more accurate conversion factors than
/// [casualConversion] based on a 400-year calendar cycle.
const Map<TimeUnit, num> accurateConversion = {
  TimeUnit.microsecond: 1,
  TimeUnit.millisecond: Duration.microsecondsPerMillisecond,
  TimeUnit.second: Duration.microsecondsPerSecond,
  TimeUnit.minute: Duration.microsecondsPerMinute,
  TimeUnit.hour: Duration.microsecondsPerHour,
  TimeUnit.day: Duration.microsecondsPerDay,
  TimeUnit.week: 7 * Duration.microsecondsPerDay,
  TimeUnit.month: _daysInMonth * Duration.microsecondsPerDay,
  TimeUnit.quarter: 3 * _daysInMonth * Duration.microsecondsPerDay,
  TimeUnit.year: _daysInYear * Duration.microsecondsPerDay,
  TimeUnit.decade: 10 * _daysInYear * Duration.microsecondsPerDay,
  TimeUnit.century: 100 * _daysInYear * Duration.microsecondsPerDay,
  TimeUnit.millennium: 1000 * _daysInYear * Duration.microsecondsPerDay,
};
const _daysInMonth = 146097.0 / 4800;
const _daysInYear = 146097.0 / 400;
