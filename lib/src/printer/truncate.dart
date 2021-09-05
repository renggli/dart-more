import 'package:characters/characters.dart';

import 'printer.dart';

extension TruncatePrinterExtension<T> on Printer<T> {
  /// Truncates the string from the left side if it is longer than width.
  Printer<T> truncateLeft(int width, [String ellipsis = '']) =>
      TruncateLeftPrinter<T>(this, width, ellipsis);

  /// Truncates the string from the right side if it is longer than width.
  Printer<T> truncateRight(int width, [String ellipsis = '']) =>
      TruncateRightPrinter<T>(this, width, ellipsis);
}

/// Truncates the string from the left side if it is longer than width.
class TruncateLeftPrinter<T> extends Printer<T> {
  const TruncateLeftPrinter(this.printer, this.width, this.ellipsis);

  final Printer<T> printer;
  final int width;
  final String ellipsis;

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
class TruncateRightPrinter<T> extends Printer<T> {
  const TruncateRightPrinter(this.printer, this.width, this.ellipsis);

  final Printer<T> printer;
  final int width;
  final String ellipsis;

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
