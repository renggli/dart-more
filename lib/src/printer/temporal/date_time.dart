import '../../../printer.dart';
import '../../functional/types/callback.dart';

/// Prints [DateTime] objects in custom ways.
class DateTimePrinter extends SequencePrinter<DateTime> {
  /// Constructor to build a [DateTimePrinter].
  factory DateTimePrinter(Callback1<DateTimePrinterBuilder> callback) {
    final builder = DateTimePrinterBuilder();
    callback(builder);
    return DateTimePrinter._(builder.printers);
  }

  /// Internal constructor for date time objects.
  DateTimePrinter._(super.printers);

  /// Returns an ISO-8601 full-precision extended format representation.
  static DateTimePrinter iso8691() => DateTimePrinter((builder) => builder
    ..year()
    ..literal('-')
    ..month()
    ..literal('-')
    ..day()
    ..literal('T')
    ..hour()
    ..literal(':')
    ..minute()
    ..literal(':')
    ..second()
    ..literal('.')
    ..millisecond()
    ..microsecond(skipIfZero: true));
}

class DateTimePrinterBuilder {
  /// Mutable list of printer objects.
  final List<Printer<DateTime>> printers = [];

  /// Adds a printer.
  void add(Printer<DateTime> printer) => printers.add(printer);

  /// Adds a literal string.
  void literal(String value) => add(LiteralPrinter<DateTime>(value));

  /// Adds a [DateTime.year] field.
  void year({int padding = 4}) => add(FixedNumberPrinter(padding: padding)
      .mapIf(padding == 2, (printer) => printer.takeLast(2))
      .map((dateTime) => dateTime.year));

  /// Adds a [DateTime.month] field.
  void month({int padding = 2}) => add(
      FixedNumberPrinter(padding: padding).map((dateTime) => dateTime.month));

  /// Adds a [DateTime.day] field.
  void day({int padding = 2}) =>
      add(FixedNumberPrinter(padding: padding).map((dateTime) => dateTime.day));

  /// Adds a [DateTime.hour] field.
  void hour({int padding = 2}) => add(
      FixedNumberPrinter(padding: padding).map((dateTime) => dateTime.hour));

  /// Adds a [DateTime.minute] field.
  void minute({int padding = 2}) => add(
      FixedNumberPrinter(padding: padding).map((dateTime) => dateTime.minute));

  /// Adds a [DateTime.second] field.
  void second({int padding = 2}) => add(
      FixedNumberPrinter(padding: padding).map((dateTime) => dateTime.second));

  /// Adds a [DateTime.millisecond] field.
  void millisecond({int padding = 3}) =>
      add(FixedNumberPrinter(padding: padding)
          .map((dateTime) => dateTime.millisecond));

  /// Adds a [DateTime.microsecond] field.
  void microsecond({int padding = 3, bool skipIfZero = false}) =>
      add(FixedNumberPrinter(padding: padding)
          .where((microsecond) => skipIfZero && microsecond != 0)
          .map((dateTime) => dateTime.microsecond));
}
