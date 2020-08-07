import '../../printer.dart';

/// Printer callback function.
typedef PrintCallback = String Function(Object? value);

/// Prints a string literal.
class PluggablePrinter extends Printer {
  final PrintCallback callback;

  const PluggablePrinter(this.callback);

  @override
  String call(Object? object) => callback(object);
}
