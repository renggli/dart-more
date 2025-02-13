import 'package:characters/characters.dart';

import '../object/object.dart';
import '../printer.dart';

extension SeparatePrinterExtension<T> on Printer<T> {
  /// Separates a string from the left side with a [separator] every [width]
  /// characters.
  Printer<T> separateLeft(int width, int offset, String separator) =>
      SeparateLeftPrinter<T>(this, width, offset, separator);

  /// Separates a string from the right side with a [separator] every [width]
  /// characters.
  Printer<T> separateRight(int width, int offset, String separator) =>
      SeparateRightPrinter<T>(this, width, offset, separator);
}

/// Separates a string with a separator character.
abstract class SeparatePrinter<T> extends Printer<T> {
  const SeparatePrinter(this.printer, this.width, this.offset, this.separator);

  final Printer<T> printer;
  final int width;
  final int offset;
  final String separator;

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter
        ..addValue(printer, name: 'printer')
        ..addValue(width, name: 'width')
        ..addValue(offset, name: 'offset')
        ..addValue(separator, name: 'separator');
}

/// Separates a string from the left with a separator character.
class SeparateLeftPrinter<T> extends SeparatePrinter<T> {
  const SeparateLeftPrinter(
    super.printer,
    super.width,
    super.offset,
    super.separator,
  );

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    final iterator = input.iterator;
    for (var i = 0; iterator.moveNext(); i++) {
      if (i != 0 && i % width == offset) {
        buffer.write(separator);
      }
      buffer.write(iterator.current);
    }
  }
}

/// Separates a string from the right with a repeated separator character.
class SeparateRightPrinter<T> extends SeparatePrinter<T> {
  const SeparateRightPrinter(
    super.printer,
    super.width,
    super.offset,
    super.separator,
  );

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    final inputLength = input.length;
    final iterator = input.iterator;
    for (var i = inputLength; iterator.moveNext(); i--) {
      if (i != inputLength && i % width == offset) {
        buffer.write(separator);
      }
      buffer.write(iterator.current);
    }
  }
}
