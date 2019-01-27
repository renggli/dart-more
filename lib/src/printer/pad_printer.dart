library more.printer.pad_printer;

import 'package:more/printer.dart';
import 'package:more/src/printer/delegate_printer.dart';

/// Pads the string on the left if it is shorter than width.
class PadLeftPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadLeftPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  String call(Object object) => super.call(object).padLeft(width, padding);
}

/// Pads the string on the right if it is shorter than width.
class PadRightPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadRightPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  String call(Object object) => super.call(object).padRight(width, padding);
}

/// Pads the string on both sides if it is shorter than width.
class PadBothPrinter extends DelegatePrinter {
  final int width;
  final String padding;

  const PadBothPrinter(Printer delegate, this.width, this.padding)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    if (result.length < width) {
      final pad = width - result.length;
      final left = pad ~/ 2;
      final right = pad ~/ 2 + pad % 2;
      return '${padding * left}$result${padding * right}';
    } else {
      return result;
    }
  }
}
