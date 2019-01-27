library more.printer.separate_printer;

import 'package:more/printer.dart';
import 'package:more/src/printer/delegate_printer.dart';

/// Separates a string from the left with a separator character.
class SeparateLeftPrinter extends DelegatePrinter {
  final int width;
  final int offset;
  final String separator;

  const SeparateLeftPrinter(
      Printer delegate, this.width, this.offset, this.separator)
      : super(delegate);

  @override
  String call(Object object) {
    final input = super.call(object);
    final buffer = StringBuffer();
    final iterator = input.codeUnits.iterator;
    for (var i = 0; iterator.moveNext(); i++) {
      if (i != 0 && i % width == offset) {
        buffer.write(separator);
      }
      buffer.writeCharCode(iterator.current);
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
  String call(Object object) {
    final input = super.call(object);
    final buffer = StringBuffer();
    final iterator = input.codeUnits.iterator;
    for (var i = 0; iterator.moveNext(); i++) {
      if (i != 0 && (input.length - i) % width == offset) {
        buffer.write(separator);
      }
      buffer.writeCharCode(iterator.current);
    }
    return buffer.toString();
  }
}
