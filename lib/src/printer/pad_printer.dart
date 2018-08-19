library more.printer.pad_printer;

import '../../printer.dart';
import 'delegate_printer.dart';
import 'utils.dart';

enum Pad {
  left,
  right,
  center,
}

class PadPrinter extends DelegatePrinter {
  final Pad _pad;

  final int _width;

  final String _padding;

  const PadPrinter(Printer delegate, this._pad, this._width, this._padding)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    if (result.length < _width) {
      switch (_pad) {
        case Pad.left:
          return result.padLeft(_width, _padding);
        case Pad.right:
          return result.padRight(_width, _padding);
        case Pad.center:
          final padding = _width - result.length;
          final left = padding ~/ 2;
          final right = padding ~/ 2 + padding % 2;
          return '${_padding * left}$result${_padding * right}';
      }
    }
    return result;
  }
}
