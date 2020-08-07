import '../../printer.dart';

/// Calls a sequence of other printers.
class SequencePrinter extends Printer {
  final List<Printer> printers;

  const SequencePrinter(this.printers);

  @override
  Printer operator +(Object other) =>
      SequencePrinter([...printers, Printer.of(other)]);

  @override
  String call(Object? object) {
    final buffer = StringBuffer();
    for (final printer in printers) {
      buffer.write(printer(object));
    }
    return buffer.toString();
  }
}
