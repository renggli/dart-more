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
  String call(Object object) {
    final input = super.call(object).characters;
    if (input.length > width) {
      return ellipsis + input.takeLast(width).toString();
    }
    return input.toString();
  }
}

/// Truncates the string from the right side if it is longer than width.
class TruncateRightPrinter extends DelegatePrinter {
  final int width;
  final String ellipsis;

  const TruncateRightPrinter(Printer delegate, this.width, this.ellipsis)
      : super(delegate);

  @override
  String call(Object object) {
    final input = super.call(object).characters;
    if (input.length > width) {
      return input.take(width).toString() + ellipsis;
    }
    return input.toString();
  }
}
