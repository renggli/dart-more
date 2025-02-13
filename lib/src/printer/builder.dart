import 'printer.dart';

extension BuilderPrinterExtension<T> on Printer<T> {
  /// Helper to modify a printer with a [callback], if a [condition] is met.
  ///
  /// This is useful to conditionally attach printer transformations while
  /// staying within the fluent interface.
  Printer<T> mapIf(
    bool condition,
    Printer<T> Function(Printer<T> printer) callback,
  ) => condition ? callback(this) : this;
}
