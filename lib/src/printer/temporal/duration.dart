import '../../../functional.dart';
import '../../../temporal.dart';
import '../builder.dart';
import '../literal.dart';
import '../number/fixed.dart';
import '../number/sign.dart';
import '../printer.dart';
import '../result_of.dart';
import '../sequence.dart';
import '../where.dart';

/// Prints [Duration] objects in custom ways.
///
/// For example, to print dates in the format `YYYY-MM-DD` call the constructor
/// and configure the printer as such:
///
/// ```dart
///  final printer = DurationPrinter((builder) => builder
///   ..part(TimeUnit.year, printer: FixedNumberPrinter<int>(padding: 4))
///   ..literal(':')
///   ..part(TimeUnit.month, printer: FixedNumberPrinter<int>(padding: 2))
///   ..literal(':')
///   ..part(TimeUnit.day, printer: FixedNumberPrinter<int>(padding: 2)));
/// print(printer(const Duration(days: 1234, seconds: 56789)));  // 0003-04-19
/// ```
class DurationPrinter extends SequencePrinter<Duration> {
  /// Constructor to build a [DurationPrinter].
  factory DurationPrinter(Callback1<DurationPrinterBuilder> callback,
      {Map<TimeUnit, num> conversion = casualConversion}) {
    final builder = DurationPrinterBuilder(conversion);
    callback(builder);
    return DurationPrinter._(builder._printers);
  }

  /// Internal constructor for [DurationPrinter].
  const DurationPrinter._(super.printers);

  /// Returns the standard Dart duration format.
  static DurationPrinter dart() => DurationPrinter((builder) => builder
    ..sign()
    ..part(TimeUnit.hour)
    ..literal(':')
    ..part(TimeUnit.minute, printer: FixedNumberPrinter(padding: 2))
    ..literal(':')
    ..part(TimeUnit.second, printer: FixedNumberPrinter(padding: 2))
    ..literal('.')
    ..part(TimeUnit.millisecond, printer: FixedNumberPrinter(padding: 3))
    ..part(TimeUnit.microsecond, printer: FixedNumberPrinter(padding: 3)));

  /// Returns an ISO-8601 extended full-precision format representation.
  static DurationPrinter iso8601() => DurationPrinter((builder) => builder
    ..literal('P')
    ..sign()
    ..part(TimeUnit.year,
        printer: FixedNumberPrinter<int>().after('Y'), skipIfZero: true)
    ..part(TimeUnit.month,
        printer: FixedNumberPrinter<int>().after('M'), skipIfZero: true)
    ..part(TimeUnit.week,
        printer: FixedNumberPrinter<int>().after('W'), skipIfZero: true)
    ..part(TimeUnit.day, printer: FixedNumberPrinter<int>().after('D'))
    ..literal('T')
    ..part(TimeUnit.hour,
        printer: FixedNumberPrinter<int>().after('H'), skipIfZero: true)
    ..part(TimeUnit.minute,
        printer: FixedNumberPrinter<int>().after('M'), skipIfZero: true)
    ..part(TimeUnit.second)
    ..part(TimeUnit.microsecond,
        printer: FixedNumberPrinter<int>(padding: 6).before('.'),
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
          .onResultOf((duration) => duration.inMicroseconds));

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
  void part(TimeUnit unit,
      {Printer<int>? printer,
      bool absoluteValue = true,
      bool skipIfZero = false}) {
    _unitParts.add(unit);
    add((printer ?? FixedNumberPrinter<int>())
        .mapIf(absoluteValue,
            (printer) => printer.onResultOf((value) => value.abs()))
        .mapIf(skipIfZero, (printer) => printer.where((value) => value != 0))
        .onResultOf((duration) => duration.convertToAll(
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
        .mapIf(absoluteValue,
            (printer) => printer.onResultOf((value) => value.abs()))
        .mapIf(skipIfZero, (printer) => printer.where((value) => value != 0))
        .onResultOf(
            (duration) => duration.convertTo(unit, conversion: _conversion)));
  }
}
