import '../functional/types/predicate.dart';
import 'object/object.dart';
import 'printer.dart';

/// Extension on [Printer] providing conditional printing.
extension WherePrinterExtension<T> on Printer<T> {
  /// Returns a printer that only prints the receiver if the [callback]
  /// evaluates to `true`.
  Printer<T> where(Predicate1<T> callback) => WherePrinter<T>(this, callback);
}

/// A printer that only prints if the callback evaluates to `true`.
class WherePrinter<T> extends Printer<T> {
  const new(this.printer, this.callback);

  final Printer<T> printer;
  final Predicate1<T> callback;

  @override
  void printOn(T object, StringBuffer buffer) {
    if (callback(object)) {
      printer.printOn(object, buffer);
    }
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(callback, name: 'callback');
}
