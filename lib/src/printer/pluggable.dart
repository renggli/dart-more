import '../../printer.dart';

/// Printer callback function.
typedef PrintCallback = String Function(Object? value);

/// Prints an object using a callback function.
class PluggablePrinter extends Printer {
  final PrintCallback callback;

  const PluggablePrinter(this.callback);

  @override
  String call(Object? object) => callback(object);
}
