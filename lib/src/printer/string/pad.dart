import 'package:characters/characters.dart';

import '../object/object.dart';
import '../printer.dart';

extension PadPrinterExtension<T> on Printer<T> {
  /// Pads the string on the left if it is shorter than [width].
  Printer<T> padLeft(int width, [String padding = ' ']) =>
      PadLeftPrinter<T>(this, width, padding);

  /// Pads the string on the right if it is shorter than [width].
  Printer<T> padRight(int width, [String padding = ' ']) =>
      PadRightPrinter<T>(this, width, padding);

  /// Pads the string on the left and right if it is shorter than [width].
  Printer<T> padBoth(int width, [String padding = ' ']) =>
      PadBothPrinter<T>(this, width, padding);
}

/// Pads the string if it is shorter than width.
abstract class PadPrinter<T> extends Printer<T> {
  const PadPrinter(this.printer, this.width, this.padding);

  final Printer<T> printer;
  final int width;
  final String padding;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(width, name: 'width')
    ..addValue(padding, name: 'padding');
}

/// Pads the string on the left if it is shorter than width.
class PadLeftPrinter<T> extends PadPrinter<T> {
  const PadLeftPrinter(super.printer, super.width, super.padding);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    final count = width - input.length;
    if (count > 0) {
      buffer.write(padding * count);
    }
    buffer.write(input);
  }
}

/// Pads the string on the right if it is shorter than width.
class PadRightPrinter<T> extends PadPrinter<T> {
  const PadRightPrinter(super.printer, super.width, super.padding);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    buffer.write(input);
    final count = width - input.length;
    if (count > 0) {
      buffer.write(padding * count);
    }
  }
}

/// Pads the string on both sides if it is shorter than width.
class PadBothPrinter<T> extends PadPrinter<T> {
  const PadBothPrinter(super.printer, super.width, super.padding);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
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
