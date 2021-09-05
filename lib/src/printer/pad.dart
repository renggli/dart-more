import 'package:characters/characters.dart';

import 'delegate.dart';
import 'printer.dart';

/// Pads the string on the left if it is shorter than width.
class PadLeftPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadLeftPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
    final count = width - input.length;
    if (count > 0) {
      buffer.write(padding * count);
    }
    buffer.write(input);
  }
}

/// Pads the string on the right if it is shorter than width.
class PadRightPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadRightPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
    buffer.write(input);
    final count = width - input.length;
    if (count > 0) {
      buffer.write(padding * count);
    }
  }
}

/// Pads the string on both sides if it is shorter than width.
class PadBothPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadBothPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
    final count = width - input.length;
    if (count > 0) {
      final left = count ~/ 2;
      if (left > 0) {
        buffer.write(padding * left);
      }
      buffer.write(input);
      final right = left + count % 2;
      if (right > 0) {
        buffer.write(padding * right);
      }
    } else {
      buffer.write(input);
    }
  }
}
