import '../object/object.dart';
import '../printer.dart';

extension TrimPrinterExtension<T> on Printer<T> {
  /// Removes any leading and trailing whitespace.
  Printer<T> trim() => TrimBothPrinter<T>(this);

  /// Removes any leading whitespace.
  Printer<T> trimLeft() => TrimLeftPrinter<T>(this);

  /// Removes any trailing whitespace.
  Printer<T> trimRight() => TrimRightPrinter<T>(this);
}

/// Removes any leading and/or trailing whitespace.
abstract class TrimPrinter<T> extends Printer<T> {
  const TrimPrinter(this.printer);

  final Printer<T> printer;

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(printer, name: 'printer');
}

/// Removes any leading and trailing whitespace.
class TrimBothPrinter<T> extends TrimPrinter<T> {
  const TrimBothPrinter(Printer<T> printer) : super(printer);

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer(object).trim());
}

/// Removes any leading whitespace.
class TrimLeftPrinter<T> extends TrimPrinter<T> {
  const TrimLeftPrinter(Printer<T> printer) : super(printer);

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer(object).trimLeft());
}

/// Removes any trailing whitespace.
class TrimRightPrinter<T> extends TrimPrinter<T> {
  const TrimRightPrinter(Printer<T> printer) : super(printer);

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(printer(object).trimRight());
}
