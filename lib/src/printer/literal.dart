import '../../printer.dart';

/// Prints a string literal.
class LiteralPrinter extends Printer {
  final String value;

  const LiteralPrinter(this.value);

  @override
  void printOn(dynamic object, StringBuffer buffer) => buffer.write(value);
}
