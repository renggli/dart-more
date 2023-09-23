import 'dart:math';

import '../../../functional.dart';
import '../../../math.dart';
import '../../../temporal.dart';
import '../builder.dart';
import '../literal.dart';
import '../number/fixed.dart';
import '../printer.dart';
import '../result_of.dart';
import '../sequence.dart';
import '../string/take_skip.dart';
import '../where.dart';

/// Prints [DateTime] objects in custom ways.
///
/// For example, to print dates in the format `YYYY-MM-DD` call the constructor
/// and configure the printer as such:
///
///     final printer = DateTimePrinter((builder) => builder
///         ..year(width: 4)
///         ..literal('-')
///         ..month(width: 2)
///         ..literal('-')
///         ..day(width: 2));
///
class DateTimePrinter extends SequencePrinter<DateTime> {
  /// Constructor to build a [DateTimePrinter].
  factory DateTimePrinter(Callback1<DateTimePrinterBuilder> callback) {
    final builder = DateTimePrinterBuilder();
    callback(builder);
    return DateTimePrinter._(builder._printers);
  }

  /// Internal constructor for [DateTimePrinter].
  const DateTimePrinter._(super.printers);

  /// Returns an ISO-8601 full-precision extended format representation.
  static DateTimePrinter iso8691() => DateTimePrinter((builder) => builder
    ..year(width: 4)
    ..literal('-')
    ..month(width: 2)
    ..literal('-')
    ..day(width: 2)
    ..literal('T')
    ..hour(width: 2)
    ..literal(':')
    ..minute(width: 2)
    ..literal(':')
    ..second(width: 2)
    ..literal('.')
    ..millisecond()
    ..microsecond(skipIfZero: true));
}

/// Builder of [DateTimePrinter] objects.
class DateTimePrinterBuilder {
  DateTimePrinterBuilder();

  final List<Printer<DateTime>> _printers = [];

  /// Adds a printer.
  void add(Printer<DateTime> printer) => _printers.add(printer);

  /// Adds a literal string.
  void literal(String value) => add(LiteralPrinter<DateTime>(value));

  /// Adds a era field.
  ///
  /// [names] specifies a list of 2 era names that are displayed instead
  /// of the default ones `['BC', 'AD']`.
  void era({List<String> names = const ['BC', 'AD']}) {
    assert(names.length == 2, '2 era names expected');
    add(Printer<int>.pluggable((index) => names[index])
        .onResultOf((dateTime) => dateTime.year > 0 ? 1 : 0));
  }

  /// Adds a [DateTime.year] field.
  ///
  /// [width] specifies the minimum number of digits to be displayed. If
  /// [width] is `2`, just the two low-order digits of the year will be
  /// displayed.
  void year({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .mapIf(width == 2, (printer) => printer.takeLast(2))
      .onResultOf((dateTime) => dateTime.year));

  /// Adds a [AccessorsDateTimeExtension.quarter] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  ///
  /// [names] specifies a list of 4 quarter names that are displayed instead
  /// of the numeric quarter number from `['Q1', ..., 'Q4']`.
  void quarter({int width = 0, List<String>? names}) {
    assert(names == null || names.length == 4, '4 quarter names expected');
    final printer = names == null
        ? FixedNumberPrinter<int>(padding: width)
        : Printer<int>.pluggable((quarter) => names[quarter - 1]);
    add(printer.onResultOf((dateTime) => dateTime.quarter));
  }

  /// Adds a [DateTime.month] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  ///
  /// [names] specifies a list of 12 month names that are displayed instead
  /// of the numeric month number from `['January', ..., 'December']`.
  void month({int width = 0, List<String>? names}) {
    assert(names == null || names.length == 12, '12 month names expected');
    final printer = names == null
        ? FixedNumberPrinter<int>(padding: width)
        : Printer<int>.pluggable((month) => names[month - 1]);
    add(printer.onResultOf((dateTime) => dateTime.month));
  }

  /// Adds a [DateTime.weekday] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  ///
  /// [names] specifies a list of 7 weekday names that are displayed instead
  /// of the numeric weekday number from `['Monday', ..., 'Sunday']`.
  void weekday({int width = 0, List<String>? names}) {
    assert(names == null || names.length == 7, '7 weekday names expected');
    final printer = names == null
        ? FixedNumberPrinter<int>(padding: width)
        : Printer<int>.pluggable((weekday) => names[weekday - 1]);
    add(printer.onResultOf((dateTime) => dateTime.weekday));
  }

  /// Adds a [AccessorsDateTimeExtension.weekNumber] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  void weekNumber({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.weekNumber));

  /// Adds a [DateTime.day] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  void day({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.day));

  /// Adds a [AccessorsDateTimeExtension.dayOfYear] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  void dayOfYear({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.dayOfYear));

  /// Adds an am/pm field.
  ///
  /// [names] specifies a list of 2 meridiem that are displayed instead
  /// of the default ones `['am', 'pm']`.
  void meridiem({List<String> names = const ['am', 'pm']}) {
    assert(names.length == 2, '2 meridiem names expected');
    add(Printer<int>.pluggable((index) => names[index])
        .onResultOf((dateTime) => dateTime.hour.between(12, 23) ? 1 : 0));
  }

  /// Adds a [DateTime.hour] field (24h-clock).
  ///
  /// [width] specifies the minimum number of digits to display.
  void hour({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.hour));

  /// Adds a [AccessorsDateTimeExtension.hour12] field (12h-clock).
  ///
  /// [width] specifies the minimum number of digits to display.
  void hour12({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.hour12));

  /// Adds a [DateTime.minute] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  void minute({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.minute));

  /// Adds a [DateTime.second] field.
  ///
  /// [width] specifies the minimum number of digits to display.
  void second({int width = 0}) => add(FixedNumberPrinter(padding: width)
      .onResultOf((dateTime) => dateTime.second));

  /// Adds a [DateTime.millisecond] field.
  ///
  /// [width] specifies the number of digits to display. If [width] is less than
  /// `3`, only the most significant digits are printed.
  void millisecond({int width = 3}) =>
      add(FixedNumberPrinter(padding: max(width, 3))
          .mapIf(width < 3, (printer) => printer.take(width))
          .onResultOf((dateTime) => dateTime.millisecond));

  /// Adds a [DateTime.microsecond] field. This field is always 0 in JavaScript.
  ///
  /// [width] specifies the number of digits to display. If [width] is less than
  /// `3`, only the most significant digits are printed.
  void microsecond({int width = 3, bool skipIfZero = false}) =>
      add(FixedNumberPrinter<int>(padding: max(width, 3))
          .mapIf(width < 3, (printer) => printer.take(width))
          .mapIf(skipIfZero, (printer) => printer.where((value) => value != 0))
          .onResultOf((dateTime) => dateTime.microsecond));
}
