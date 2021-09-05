import 'printer.dart';

extension EmptyPrinterExtension<T> on Printer<Iterable<T>> {
  /// Prints [label], if the iterable to be printed is empty. Uses the unicode
  /// symbol for empty set by default: https://unicode-table.com/en/2205/.
  Printer<Iterable<T>> ifEmpty([String label = '\u2205']) =>
      EmptyPrinter<T>(this, label);
}

/// Prints an object different if `null`.
class EmptyPrinter<T> extends Printer<Iterable<T>> {
  const EmptyPrinter(this.printer, this.label);

  final Printer<Iterable<T>> printer;
  final String label;

  @override
  void printOn(Iterable<T> object, StringBuffer buffer) =>
      object.isEmpty ? buffer.write(label) : printer.printOn(object, buffer);
}
