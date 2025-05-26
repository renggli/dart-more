import '../../../functional.dart';
import '../printer.dart';
import 'field.dart';
import 'object.dart';

/// A field with a constant value.
class FieldValue<T, F> extends FieldPrinter<T> {
  FieldValue(
    this.name,
    this.value,
    this.omitNull,
    this.omitPredicate,
    this.printer,
  );

  @override
  final String? name;
  final F value;
  final bool omitNull;
  final Predicate1<F>? omitPredicate;
  final Printer<F> printer;

  @override
  bool isOmitted(T object) {
    if (omitNull && value == null) {
      return true;
    }
    if (omitPredicate != null && omitPredicate!(value)) {
      return true;
    }
    return false;
  }

  @override
  void printOn(T object, StringBuffer buffer) => printer.printOn(value, buffer);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(value, name: 'value')
    ..addValue(omitNull, name: 'omitNull')
    ..addValue(omitPredicate, name: 'omitPredicate')
    ..addValue(printer, name: 'printer');
}
