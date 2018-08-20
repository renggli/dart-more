library more.printer.truncate_printer;

import '../../printer.dart';
import 'delegate_printer.dart';

/// Truncates the string from the left side if it is longer than width.
class TruncateLeftPrinter extends DelegatePrinter {
  final int _width;
  final String _ellipsis;

  const TruncateLeftPrinter(Printer delegate, this._width, this._ellipsis)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    return result.length > _width
        ? _ellipsis + result.substring(result.length - _width)
        : result;
  }
}

/// Truncates the string from the right side if it is longer than width.
class TruncateRightPrinter extends DelegatePrinter {
  final int _width;
  final String _ellipsis;

  const TruncateRightPrinter(Printer delegate, this._width, this._ellipsis)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    return result.length > _width
        ? result.substring(0, _width) + _ellipsis
        : result;
  }
}
