import '../../printer.dart';

/// Calls the standard [toString] method.
class StandardPrinter extends Printer {
  const StandardPrinter();

  @override
  String call(Object? object) => object.toString();
}
