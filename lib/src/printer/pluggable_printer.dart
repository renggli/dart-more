library more.printer.pluggable_printer;

import '../../printer.dart';

typedef String ToString(Object object);

/// Prints a string literal.
class PluggablePrinter extends Printer {
  final ToString callback;

  const PluggablePrinter(this.callback);

  @override
  String call(Object object) => callback(object);
}
