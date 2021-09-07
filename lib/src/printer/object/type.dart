import '../printer.dart';

/// Printer of the dynamic runtime type.
class TypePrinter<T> extends Printer<T> {
  const TypePrinter();

  @override
  void printOn(T object, StringBuffer buffer) =>
      buffer.write(object.runtimeType);
}
