library more.printer.literal;

import '../../printer.dart';

/// Prints a string literal.
class LiteralPrinter extends Printer {
  final String value;

  const LiteralPrinter(this.value);

  @override
  String call(Object object) => value;
}
