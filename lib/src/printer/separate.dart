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
  String call(dynamic object) {
    final buffer = StringBuffer();
    final input = super.call(object).characters;
    final iterator = input.iterator;
    for (var i = 0; iterator.moveNext(); i++) {
      if (buffer.isNotEmpty && i % width == offset) {
        buffer.write(separator);
      }
      buffer.write(iterator.current);
    }
    return buffer.toString();
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
  String call(dynamic object) {
    final buffer = StringBuffer();
    final input = super.call(object).characters;
    final iterator = input.iterator;
    for (var i = input.length; iterator.moveNext(); i--) {
      if (buffer.isNotEmpty && i % width == offset) {
        buffer.write(separator);
      }
      buffer.write(iterator.current);
    }
    return buffer.toString();
  }
}
