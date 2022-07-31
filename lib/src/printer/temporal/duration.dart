import '../../../functional.dart';
import '../../../temporal.dart';
import '../../temporal/conversion.dart';
import '../builder.dart';
import '../literal.dart';
import '../map.dart';
import '../number/fixed.dart';
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

  /// Returns an ISO-8601 full-precision extended format representation.
  static DurationPrinter iso8601() => DurationPrinter((builder) => builder
    ..literal('P')
    ..addPart(TimeUnit.year, FixedNumberPrinter<int>().after('Y'),
        skipIfZero: true)
    ..addPart(TimeUnit.month, FixedNumberPrinter<int>().after('M'),
        skipIfZero: true)
    ..addPart(TimeUnit.week, FixedNumberPrinter<int>().after('W'),
        skipIfZero: true)
    ..addPart(TimeUnit.day, FixedNumberPrinter<int>().after('D'))
    ..literal('T')
    ..addPart(TimeUnit.hour, FixedNumberPrinter<int>().after('H'),
        skipIfZero: true)
    ..addPart(TimeUnit.minute, FixedNumberPrinter<int>().after('M'),
        skipIfZero: true)
    ..addPart(TimeUnit.second, FixedNumberPrinter<int>().after('S')));
}

/// Builder of [DurationPrinter] objects.
class DurationPrinterBuilder {
  DurationPrinterBuilder(this._conversion);

  final Map<TimeUnit, num> _conversion;
  final List<Printer<Duration>> _printers = [];
  final Set<TimeUnit> _parts = {};

  /// Adds a printer.
  void add(Printer<Duration> printer) => _printers.add(printer);

  /// Adds a literal string.
  void literal(String value) => add(LiteralPrinter<Duration>(value));

  /// Adds a printer that prints a part of a duration unit.
  void addPart(TimeUnit unit, Printer<int> printer, {bool skipIfZero = false}) {
    _parts.add(unit);
    add(printer
        .mapIf(skipIfZero, (printer) => printer.where((value) => value != 0))
        .map<Duration>((duration) =>
            duration.convertToAll(_parts, conversion: _conversion)[unit]!));
  }
}
