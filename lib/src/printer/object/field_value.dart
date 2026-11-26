import '../../functional/types/predicate.dart';
import '../printer.dart';
import 'field.dart';
import 'object.dart';

/// A field with a constant value.
class FieldValue<T, F> extends FieldPrinter<T> {
  /// Constructs a field printer with a constant [value].
  new(this.name, this.value, this.omitNull, this.omitPredicate, this.printer);

  @override
  final String? name;

  /// The constant value of the field.
  final F value;

  /// Whether `null` values are omitted.
  final bool omitNull;

  /// Optional predicate deciding whether to omit the field.
  final Predicate1<F>? omitPredicate;

  /// Printer used to format [value].
  final Printer<F> printer;

  @override
  bool isOmitted(T object) {
    if (omitNull && value == null) {
      return true;
    }
    if (omitPredicate case final predicate? when predicate(value)) {
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
