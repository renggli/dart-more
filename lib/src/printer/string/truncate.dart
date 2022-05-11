import 'package:characters/characters.dart';

import '../object/object.dart';
import '../printer.dart';

extension TruncatePrinterExtension<T> on Printer<T> {
  /// Truncates the string from the left side if it is longer than width.
  Printer<T> truncateLeft(int width, [String ellipsis = '']) =>
      TruncateLeftPrinter<T>(this, width, ellipsis);

  /// Truncates the string from the right side if it is longer than width.
  Printer<T> truncateRight(int width, [String ellipsis = '']) =>
      TruncateRightPrinter<T>(this, width, ellipsis);
}

/// Truncates the string if it is longer than width.
abstract class TruncatePrinter<T> extends Printer<T> {
  const TruncatePrinter(this.printer, this.width, this.ellipsis);

  final Printer<T> printer;
  final int width;
  final String ellipsis;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(width, name: 'width')
    ..addValue(ellipsis, name: 'ellipsis');
}

/// Truncates the string from the left side if it is longer than width.
class TruncateLeftPrinter<T> extends TruncatePrinter<T> {
  const TruncateLeftPrinter(super.printer, super.width, super.ellipsis);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    if (input.length > width) {
      buffer.write(ellipsis);
      buffer.write(input.takeLast(width));
    } else {
      buffer.write(input);
    }
  }
}

/// Truncates the string from the right side if it is longer than width.
class TruncateRightPrinter<T> extends TruncatePrinter<T> {
  const TruncateRightPrinter(super.printer, super.width, super.ellipsis);

  @override
  void printOn(T object, StringBuffer buffer) {
    final input = printer(object).characters;
    if (input.length > width) {
      buffer.write(input.take(width));
      buffer.write(ellipsis);
    } else {
      buffer.write(input);
    }
  }
}
