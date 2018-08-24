library more.printer.separate_printer;

import '../../printer.dart';
import 'delegate_printer.dart';

/// Separates a string from the left with a separator character.
class SeparateLeftPrinter extends DelegatePrinter {
  final int _width;
  final int _offset;
  final String _separator;

  const SeparateLeftPrinter(
      Printer delegate, this._width, this._offset, this._separator)
      : super(delegate);

  @override
  String call(Object object) {
    final input = super.call(object);
    final buffer = StringBuffer();
    final iterator = input.codeUnits.iterator;
    for (var i = 0; iterator.moveNext(); i++) {
      if (i != 0 && i % _width == _offset) {
        buffer.write(_separator);
      }
      buffer.writeCharCode(iterator.current);
    }
    return buffer.toString();
  }
}

/// Separates a string from the right with a repeated separator character.
class SeparateRightPrinter extends DelegatePrinter {
  final int _width;
  final int _offset;
  final String _separator;

  const SeparateRightPrinter(
      Printer delegate, this._width, this._offset, this._separator)
      : super(delegate);

  @override
  String call(Object object) {
    final input = super.call(object);
    final buffer = StringBuffer();
    final iterator = input.codeUnits.iterator;
    for (var i = 0; iterator.moveNext(); i++) {
      if (i != 0 && (input.length - i) % _width == _offset) {
        buffer.write(_separator);
      }
      buffer.writeCharCode(iterator.current);
    }
    return buffer.toString();
  }
}
