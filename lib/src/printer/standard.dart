import 'printer.dart';

/// Calls the standard [toString] method.
class StandardPrinter<T> extends Printer<T> {
  const StandardPrinter();

  @override
  void printOn(T object, StringBuffer buffer) => buffer.write(object);
}
