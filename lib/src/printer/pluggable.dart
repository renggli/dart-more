import '../../printer.dart';

/// Printer callback function.
typedef PrintCallback = String Function(dynamic value);

/// Prints an object using a callback function.
class PluggablePrinter extends Printer {
  final PrintCallback callback;

  const PluggablePrinter(this.callback);

  @override
  void printOn(dynamic object, StringBuffer buffer) =>
      buffer.write(callback(object));
}
