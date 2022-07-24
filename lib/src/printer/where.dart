import '../functional/types/predicate.dart';
import 'object/object.dart';
import 'printer.dart';

extension WherePrinterExtension<T> on Printer<T> {
  /// Returns a printer that only prints the receiver if the [predicate]
  /// evaluates to `true`.
  Printer<T> where(Predicate1<T> callback) => WherePrinter<T>(this, callback);
}

class WherePrinter<T> extends Printer<T> {
  const WherePrinter(this.printer, this.predicate);

  final Printer<T> printer;
  final Predicate1<T> predicate;

  @override
  void printOn(T object, StringBuffer buffer) {
    if (predicate(object)) {
      printer.printOn(object, buffer);
    }
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(predicate, name: 'predicate');
}
