import 'package:characters/characters.dart';

import '../../printer.dart';
import 'delegate.dart';

/// Pads the string on the left if it is shorter than width.
class PadLeftPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadLeftPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  String call(Object? object) {
    final input = super.call(object).characters;
    final count = width - input.length;
    if (count > 0) {
      return '${padding * count}${input}';
    }
    return input.toString();
  }
}

/// Pads the string on the right if it is shorter than width.
class PadRightPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadRightPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  String call(Object? object) {
    final input = super.call(object).characters;
    final count = width - input.length;
    if (count > 0) {
      return '${input}${padding * count}';
    }
    return input.toString();
  }
}

/// Pads the string on both sides if it is shorter than width.
class PadBothPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadBothPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  String call(Object? object) {
    final input = super.call(object).characters;
    final count = width - input.length;
    if (count > 0) {
      final left = count ~/ 2;
      final right = count ~/ 2 + count % 2;
      return '${padding * left}${input}${padding * right}';
    }
    return input.toString();
  }
}
