import 'time_unit.dart';

/// Type definition of a [Map] of conversion factors for different [TimeUnit]s.
typedef UnitConversion = Map<TimeUnit, num>;

/// Casual conversion scheme from different [TimeUnit]s to microseconds.
///
/// This naive conversion assumes that a month has 30 days and a year has
/// 365 days. While this is the default for all operations, it is not typically
/// correct or event consistent.
const UnitConversion casualConversion = {
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
/// [casualConversion] and is based on a 400-year calendar cycle.
const UnitConversion accurateConversion = {
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
const double _daysInMonth = 146097 / 4800;
const double _daysInYear = 146097 / 400;
