library more.printer.literal_printer;

import '../../printer.dart';

class LiteralPrinter extends Printer {
  final String value;

  const LiteralPrinter(this.value);

  @override
  String call(Object object) => value;
}
