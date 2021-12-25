import 'object/object.dart';
import 'printer.dart';

/// Prints a string literal.
class LiteralPrinter<T> extends Printer<T> {
  const LiteralPrinter([this.value = '']);

  final String value;

  @override
  void printOn(void object, StringBuffer buffer) => buffer.write(value);

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(value, name: 'value');
}
