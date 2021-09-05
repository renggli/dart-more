import 'printer.dart';

extension SequencePrinterExtension<T> on Printer<T> {
  /// Prints before another printer.
  Printer<T> before(Object other) =>
      SequencePrinter<T>([Printer<T>.wrap(other), this]);

  /// Prints something after another printer.
  Printer<T> after(Object other) =>
      SequencePrinter<T>([this, Printer<T>.wrap(other)]);

  /// Prints something before and after another printer.
  Printer<T> around(Object first, [Object? second]) => SequencePrinter<T>(
      [Printer<T>.wrap(first), this, Printer<T>.wrap(second ?? first)]);
}

/// Prints a sequence of printers.
class SequencePrinter<T> extends Printer<T> {
  const SequencePrinter(this.printers);

  final Iterable<Printer<T>> printers;

  @override
  void printOn(T object, StringBuffer buffer) {
    for (final printer in printers) {
      printer.printOn(object, buffer);
    }
  }
}
