import '../functional/types/mapping.dart';
import 'object/object.dart';
import 'printer.dart';

extension ResultOfPrinterExtension<R> on Printer<R> {
  /// Returns a printer that accepts values of type [T] and invokes the provided
  /// `callback` to transform it to type [R] for printing.
  Printer<T> onResultOf<T>(Map1<T, R> function) =>
      ResultOfPrinter<T, R>(this, function);

  /// Returns a printer that accepts values of type [T] and invokes the provided
  /// `callback` to transform it to type [R] for printing.
  @Deprecated('Use `onResultOf` instead.')
  Printer<T> map<T>(Map1<T, R> function) => onResultOf<T>(function);

  /// Returns a printer that accepts values of type [T] and casts them to [R]
  /// for printing.
  Printer<T> cast<T>() => onResultOf<T>((value) => value as R);
}

class ResultOfPrinter<T, R> extends Printer<T> {
  const ResultOfPrinter(this.printer, this.function);

  final Printer<R> printer;
  final Map1<T, R> function;

  @override
  void printOn(T object, StringBuffer buffer) =>
      printer.printOn(function(object), buffer);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(printer, name: 'printer')
    ..addValue(function, name: 'callback');
}
