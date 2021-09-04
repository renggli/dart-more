import 'package:characters/characters.dart';

import '../../printer.dart';
import 'delegate.dart';

/// Separates a string from the left with a separator character.
class SeparateLeftPrinter extends DelegatePrinter {
  final int width;
  final int offset;
  final String separator;

  const SeparateLeftPrinter(
      Printer delegate, this.width, this.offset, this.separator)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
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
class SeparateRightPrinter extends DelegatePrinter {
  final int width;
  final int offset;
  final String separator;

  const SeparateRightPrinter(
      Printer delegate, this.width, this.offset, this.separator)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
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
