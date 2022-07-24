import '../functional/types/mapping.dart';
import 'object/object.dart';
import 'printer.dart';

extension MapPrinterExtension<R> on Printer<R> {
  /// Returns a printer that accepts values of type [T] and invokes the provided
  /// `callback` to transform it to type [R] for printing.
  Printer<T> map<T>(Map1<T, R> callback) => MapPrinter<T, R>(this, callback);

  /// Returns a printer that accepts values of type [T] and casts them to [R]
  /// for printing.
  Printer<T> cast<T>() => MapPrinter<T, R>(this, (value) => value as R);
}

class MapPrinter<T, R> extends Printer<T> {
  const MapPrinter(this.printer, this.callback);

  final Printer<R> printer;
  final Map1<T, R> callback;

  @override
  void printOn(T object, StringBuffer buffer) =>
      printer.printOn(callback(object), buffer);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(callback, name: 'callback');
}
