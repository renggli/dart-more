library more.printer.standard_printer;

import 'package:more/printer.dart';

/// Calls the standard [toString] method.
class StandardPrinter extends Printer {
  const StandardPrinter();

  @override
  String call(Object object) => object.toString();
}
