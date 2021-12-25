import '../functional/types/mapping.dart';
import 'object/object.dart';
import 'printer.dart';

/// Evaluates the callback with the value to retrieve the string.
class PluggablePrinter<T> extends Printer<T> {
  const PluggablePrinter(this.callback);

  final Map1<T, String> callback;

  @override
  void printOn(T object, StringBuffer buffer) => buffer.write(callback(object));

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(callback, name: 'callback');
}
