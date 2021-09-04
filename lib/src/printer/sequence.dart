import '../../printer.dart';

/// Calls a sequence of other printers.
class SequencePrinter extends Printer {
  final List<Printer> printers;

  const SequencePrinter(this.printers);

  @override
  Printer operator +(Object other) =>
      SequencePrinter([...printers, Printer.of(other)]);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    for (final printer in printers) {
      buffer.write(printer(object));
    }
  }
}
