import 'printer.dart';

/// Calls the standard [toString] method.
class StandardPrinter extends Printer {
  const StandardPrinter();

  @override
  void printOn(dynamic object, StringBuffer buffer) => buffer.write(object);
}
