library more.printer.trim_printer;

import 'package:more/printer.dart';
import 'package:more/src/printer/delegate_printer.dart';

/// Removes any leading and trailing whitespace.
class TrimPrinter extends DelegatePrinter {
  const TrimPrinter(Printer delegate) : super(delegate);

  @override
  String call(Object object) => super.call(object).trim();
}

/// Removes any leading whitespace.
class TrimLeftPrinter extends DelegatePrinter {
  const TrimLeftPrinter(Printer delegate) : super(delegate);

  @override
  String call(Object object) => super.call(object).trimLeft();
}

/// Removes any trailing whitespace.
class TrimRightPrinter extends DelegatePrinter {
  const TrimRightPrinter(Printer delegate) : super(delegate);

  @override
  String call(Object object) => super.call(object).trimRight();
}
