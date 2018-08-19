library more.printer.pluggable_printer;

import '../../printer.dart';

typedef String ToString(Object object);

/// Prints a string literal.
class PluggablePrinter extends Printer {
  final ToString _callback;

  const PluggablePrinter(this._callback);

  @override
  String call(Object object) => _callback(object);
}
