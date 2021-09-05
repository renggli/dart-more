import '../functional/types/mapping.dart';
import 'printer.dart';

extension TransformPrinterExtension<R> on Printer<R> {
  /// Returns a printer that accepts values of type [T] and invokes the provided
  /// `callback` to transform it to type [R] for printing.
  Printer<T> map<T>(Map1<T, R> callback) =>
      TransformPrinter<T, R>(this, callback);

  /// Returns a printer that accepts values of type [T] and casts them to [R]
  /// for printing.
  Printer<T> cast<T>() => TransformPrinter<T, R>(this, (value) => value as R);
}

/// Prints an object different if `null`.
class TransformPrinter<T, R> extends Printer<T> {
  const TransformPrinter(this.printer, this.callback);

  final Printer<R> printer;
  final Map1<T, R> callback;

  @override
  void printOn(T object, StringBuffer buffer) =>
      printer.printOn(callback(object), buffer);
}
