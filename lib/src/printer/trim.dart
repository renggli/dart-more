import 'printer.dart';

extension TrimPrinterExtension<T> on Printer<T> {
  /// Removes any leading and trailing whitespace.
  Printer<T> trim() => TrimPrinter<T>(this);

  /// Removes any leading whitespace.
  Printer<T> trimLeft() => TrimLeftPrinter<T>(this);

  /// Removes any trailing whitespace.
  Printer<T> trimRight() => TrimRightPrinter<T>(this);
}

/// Removes any leading and trailing whitespace.
class TrimPrinter<T> extends Printer<T> {
  const TrimPrinter(this.printer);

  final Printer<T> printer;

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer(object).trim());
}

/// Removes any leading whitespace.
class TrimLeftPrinter<T> extends Printer<T> {
  const TrimLeftPrinter(this.printer);

  final Printer<T> printer;

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer(object).trimLeft());
}

/// Removes any trailing whitespace.
class TrimRightPrinter<T> extends Printer<T> {
  const TrimRightPrinter(this.printer);

  final Printer<T> printer;

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer(object).trimRight());
}
