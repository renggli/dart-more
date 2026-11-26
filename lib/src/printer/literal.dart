import 'object/object.dart';
import 'printer.dart';

/// Prints a string literal.
class LiteralPrinter<T> extends Printer<T> {
  /// Constructs a literal printer emitting [value].
  const new([this.value = '']);

  /// The literal string emitted by this printer.
  final String value;

  @override
  void printOn(void object, StringBuffer buffer) => buffer.write(value);

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(value, name: 'value');
}
