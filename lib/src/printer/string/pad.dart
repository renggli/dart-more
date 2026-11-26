import 'package:characters/characters.dart';

import '../object/object.dart';
import '../printer.dart';

/// Extension on [Printer] providing padding operations.
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
  /// Constructs a padding printer with target [width] and [padding] string.
  const new(this.printer, this.width, this.padding);

  /// The delegate printer whose output is padded.
  final Printer<T> printer;

  /// The target minimum width in characters.
  final int width;

  /// The padding string repeated as needed.
  final String padding;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(width, name: 'width')
    ..addValue(padding, name: 'padding');
}

/// Pads the string on the left if it is shorter than width.
class PadLeftPrinter<T> extends PadPrinter<T> {
  /// Constructs a left-padding printer.
  const new(super.printer, super.width, super.padding);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    final count = width - input.length;
    for (var i = 0; i < count; i++) {
      buffer.write(padding);
    }
    buffer.write(input);
  }
}

/// Pads the string on the right if it is shorter than width.
class PadRightPrinter<T> extends PadPrinter<T> {
  /// Constructs a right-padding printer.
  const new(super.printer, super.width, super.padding);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    buffer.write(input);
    final count = width - input.length;
    for (var i = 0; i < count; i++) {
      buffer.write(padding);
    }
  }
}

/// Pads the string on both sides if it is shorter than width.
class PadBothPrinter<T> extends PadPrinter<T> {
  /// Constructs a symmetric-padding printer.
  const new(super.printer, super.width, super.padding);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    final count = width - input.length;
    if (count > 0) {
      final left = count ~/ 2;
      for (var i = 0; i < left; i++) {
        buffer.write(padding);
      }
      buffer.write(input);
      final right = left + count % 2;
      for (var i = 0; i < right; i++) {
        buffer.write(padding);
      }
    } else {
      buffer.write(input);
    }
  }
}
