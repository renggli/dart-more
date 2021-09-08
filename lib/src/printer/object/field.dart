import '../printer.dart';

/// Abstract field description.
abstract class FieldPrinter<T> extends Printer<T> {
  /// Returns an optional name for the field.
  String? get name;

  /// Returns true if the field should be omitted from display.
  bool isOmitted(T object);
}
