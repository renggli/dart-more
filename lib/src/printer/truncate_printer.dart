library more.printer.truncate_printer;

import 'package:more/printer.dart';
import 'package:more/src/printer/delegate_printer.dart';

/// Truncates the string from the left side if it is longer than width.
class TruncateLeftPrinter extends DelegatePrinter {
  final int width;
  final String ellipsis;

  const TruncateLeftPrinter(Printer delegate, this.width, this.ellipsis)
      : super(delegate);

  @override
  String call(Object object) {
    final result = super.call(object);
    return result.length > width
        ? ellipsis + result.substring(result.length - width)
        : result;
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
    final result = super.call(object);
    return result.length > width
        ? result.substring(0, width) + ellipsis
        : result;
  }
}
