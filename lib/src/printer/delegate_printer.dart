library more.printer.crop_printer;

import 'package:more/printer.dart';

/// Delegates a printer to another one.
class DelegatePrinter extends Printer {
  final Printer delegate;

  const DelegatePrinter(this.delegate);

  @override
  String call(Object object) => delegate(object);
}
