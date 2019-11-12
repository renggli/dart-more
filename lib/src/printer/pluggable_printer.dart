library more.printer.pluggable_printer;

import '../../printer.dart';

/// Prints a string literal.
class PluggablePrinter extends Printer {
  final Function callback;

  const PluggablePrinter(this.callback);

  @override
  String call(Object object) => callback(object);
}
