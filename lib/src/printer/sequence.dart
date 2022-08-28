import 'object/object.dart';
import 'printer.dart';

extension SequencePrinterPrinterExtension<T> on Printer<T> {
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

extension SequencePrinterIterableExtension<T> on Iterable<Printer<T>> {
  /// Constructs a sequence of printers.
  Printer<T> toPrinter() => SequencePrinter<T>(this);
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

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(printers, name: 'printers');
}
