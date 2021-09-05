import '../functional/types/mapping.dart';
import 'printer.dart';

/// Pads the string on the left if it is shorter than width.
class PluggablePrinter<T> extends Printer<T> {
  const PluggablePrinter(this.callback);

  final Map1<T, String> callback;

  @override
  void printOn(T object, StringBuffer buffer) => buffer.write(callback(object));
}
