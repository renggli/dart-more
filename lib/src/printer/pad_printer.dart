library more.printer.pad_printer;

import '../../printer.dart';
import 'delegate_printer.dart';

/// Pads the string on the left if it is shorter than width.
class PadLeftPrinter extends DelegatePrinter {
  final int _width;
  final String _padding;

  const PadLeftPrinter(Printer delegate, this._width, this._padding)
      : super(delegate);

  @override
  String call(Object object) => super.call(object).padLeft(_width, _padding);
}

/// Pads the string on the right if it is shorter than width.
class PadRightPrinter extends DelegatePrinter {
  final int _width;
  final String _padding;

  const PadRightPrinter(Printer delegate, this._width, this._padding)
      : super(delegate);

  @override
  String call(Object object) => super.call(object).padRight(_width, _padding);
}

/// Pads the string on both sides if it is shorter than width.
class PadBothPrinter extends DelegatePrinter {
  final int _width;
  final String _padding;

  const PadBothPrinter(Printer delegate, this._width, this._padding)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    if (result.length < _width) {
      final padding = _width - result.length;
      final left = padding ~/ 2;
      final right = padding ~/ 2 + padding % 2;
      return '${_padding * left}$result${_padding * right}';
    } else {
      return result;
    }
  }
}
