import 'package:characters/characters.dart';

import '../../printer.dart';
import 'delegate.dart';

/// Truncates the string from the left side if it is longer than width.
class TruncateLeftPrinter extends DelegatePrinter {
  final int width;
  final String ellipsis;

  const TruncateLeftPrinter(Printer delegate, this.width, this.ellipsis)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
    if (input.length > width) {
      buffer.write(ellipsis);
      buffer.write(input.takeLast(width));
    } else {
      buffer.write(input);
    }
  }
}

/// Truncates the string from the right side if it is longer than width.
class TruncateRightPrinter extends DelegatePrinter {
  final int width;
  final String ellipsis;

  const TruncateRightPrinter(Printer delegate, this.width, this.ellipsis)
      : super(delegate);

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final input = delegate(object).characters;
    if (input.length > width) {
      buffer.write(input.take(width));
      buffer.write(ellipsis);
    } else {
      buffer.write(input);
    }
  }
}
