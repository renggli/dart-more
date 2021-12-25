import 'object/object.dart';
import 'printer.dart';

extension NullPrinterExtension<T> on Printer<T> {
  /// Prints [label], if the object to be printed is null. Uses the unicode
  /// symbol for null by default: https://unicode-table.com/en/2400/.
  Printer<T?> ifNull([String label = '\u2400']) => NullPrinter<T>(this, label);
}

/// Prints an object different if `null`.
class NullPrinter<T> extends Printer<T?> {
  const NullPrinter(this.printer, this.label);

  final Printer<T> printer;
  final String label;

  @override
  void printOn(T? object, StringBuffer buffer) =>
      object == null ? buffer.write(label) : printer.printOn(object, buffer);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(label, name: 'label');
}
