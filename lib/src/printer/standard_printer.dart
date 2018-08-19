library more.printer.standard_printer;

import '../../printer.dart';

class StandardPrinter extends Printer {
  const StandardPrinter();

  @override
  String call(Object object) => object.toString();
}
