import '../../../functional.dart';
import '../../../temporal.dart';
import '../../temporal/conversion.dart';
import '../builder.dart';
import '../literal.dart';
import '../map.dart';
import '../number/fixed.dart';
import '../number/sign.dart';
import '../printer.dart';
import '../sequence.dart';
import '../where.dart';

/// Prints [Duration] objects in custom ways.
///
/// For example, to print dates in the format `YYYY-MM-DD` call the constructor
/// and configure the printer as such:
///
///     final printer = DurationPrinter((builder) => builder
///         ..year(width: 4)
///         ..literal('-')
///         ..month(width: 2)
///         ..literal('-')
///         ..day(width: 2));
///
class DurationPrinter extends SequencePrinter<Duration> {
  /// Constructor to build a [DurationPrinter].
  factory DurationPrinter(Callback1<DurationPrinterBuilder> callback,
      {Map<TimeUnit, num> conversion = casualConversion}) {
    final builder = DurationPrinterBuilder(conversion);
    callback(builder);
    return DurationPrinter._(builder._printers);
  }

  /// Internal constructor for [DurationPrinter].
  DurationPrinter._(super.printers);

  /// Returns the standard Dart duration format.
  static DurationPrinter dart() => DurationPrinter((builder) => builder
    ..sign()
    ..part(TimeUnit.hour, FixedNumberPrinter())
    ..literal(':')
    ..part(TimeUnit.minute, FixedNumberPrinter(padding: 2))
    ..literal(':')
    ..part(TimeUnit.second, FixedNumberPrinter(padding: 2))
    ..literal('.')
    ..part(TimeUnit.millisecond, FixedNumberPrinter(padding: 3))
    ..part(TimeUnit.microsecond, FixedNumberPrinter(padding: 3)));

  /// Returns an ISO-8601 extended full-precision format representation.
  static DurationPrinter iso8601() => DurationPrinter((builder) => builder
    ..literal('P')
    ..sign()
    ..part(TimeUnit.year, FixedNumberPrinter<int>().after('Y'),
        skipIfZero: true)
    ..part(TimeUnit.month, FixedNumberPrinter<int>().after('M'),
        skipIfZero: true)
    ..part(TimeUnit.week, FixedNumberPrinter<int>().after('W'),
        skipIfZero: true)
    ..part(TimeUnit.day, FixedNumberPrinter<int>().after('D'))
    ..literal('T')
    ..part(TimeUnit.hour, FixedNumberPrinter<int>().after('H'),
        skipIfZero: true)
    ..part(TimeUnit.minute, FixedNumberPrinter<int>().after('M'),
        skipIfZero: true)
    ..part(TimeUnit.second, FixedNumberPrinter<int>())
    ..part(
        TimeUnit.microsecond, FixedNumberPrinter<int>(padding: 6).before('.'),
        skipIfZero: true)
    ..literal('S'));
}

/// Builder of [DurationPrinter] objects.
class DurationPrinterBuilder {
  DurationPrinterBuilder(this._conversion);

  final Map<TimeUnit, num> _conversion;
  final List<Printer<Duration>> _printers = [];
  final Set<TimeUnit> _unitParts = {};

  /// Adds a printer.
  void add(Printer<Duration> printer) => _printers.add(printer);

  /// Adds a literal string.
  void literal(String value) => add(LiteralPrinter<Duration>(value));

  /// Adds a sign printer.
  void sign([SignNumberPrinter<int>? printer]) =>
      add((printer ?? const SignNumberPrinter.omitPositiveSign())
          .map((duration) => duration.inMicroseconds));

  /// Adds a printer that prints a part of a duration unit.
  ///
  /// The printed [int] value is a part of the duration and distributed among
  /// all other parts of this printer. Larger units are preferred over smaller
  /// units. Units below the smallest part are ignored.
  ///
  /// By default the absolute value of all units is printed, unless
  /// `absoluteValue` is set to `false`.
  ///
  /// If `skipIfZero` is set to `true` the unit is skipped if it is zero.
  ///
  /// See [ConvertToAllDurationExtension.convertToAll] for details.
  void part(TimeUnit unit, Printer<int> printer,
      {bool absoluteValue = true, bool skipIfZero = false}) {
    _unitParts.add(unit);
    add(printer
        .mapIf(absoluteValue, (printer) => printer.map((value) => value.abs()))
        .mapIf(skipIfZero, (printer) => printer.where((value) => value != 0))
        .map((duration) => duration.convertToAll(
              _unitParts,
              conversion: _conversion,
            )[unit]!));
  }

  /// Adds a printer that prints the full duration of the provided unit.
  ///
  /// The printed [double] value is fractional duration in the selected unit. It
  /// represents the complete duration.
  ///
  /// By default signed value of the unit is printed, unless `absoluteValue` is
  /// set to `true`.
  ///
  /// If `skipIfZero` is set to `true` the unit is skipped if it is zero.
  ///
  /// See [ConvertToDurationExtension.convertTo] for details.
  void full(TimeUnit unit, Printer<double> printer,
      {bool absoluteValue = false, bool skipIfZero = false}) {
    add(printer
        .mapIf(absoluteValue, (printer) => printer.map((value) => value.abs()))
        .mapIf(skipIfZero, (printer) => printer.where((value) => value != 0))
        .map((duration) => duration.convertTo(unit, conversion: _conversion)));
  }
}
