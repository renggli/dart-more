import '../../functional/types.dart';
import '../printer.dart';
import 'field.dart';
import 'field_value.dart';
import 'object.dart';

/// Internal single-evaluation interface for [FieldCallback].
abstract interface class EvaluatableField<T> {
  /// Evaluates the field for [object], returning `null` if omitted or a
  /// resolved [FieldPrinter] bound to the computed value.
  FieldPrinter<T>? evaluate(T object);
}

/// A field that is computed from a callback.
class FieldCallback<T, F> extends FieldPrinter<T>
    implements EvaluatableField<T> {
  /// Constructs a callback-backed field printer.
  new(
    this.name,
    this.callback,
    this.omitNull,
    this.omitPredicate,
    this.printer,
  );

  @override
  final String? name;

  /// Callback computing the field value from the target object.
  final Map1<T, F> callback;

  /// Whether `null` field values are omitted.
  final bool omitNull;

  /// Optional predicate deciding whether to omit the field.
  final Predicate2<T, F>? omitPredicate;

  /// Printer used to format the computed field value.
  final Printer<F> printer;

  @override
  FieldPrinter<T>? evaluate(T object) {
    if (!omitNull && omitPredicate == null) {
      return this;
    }
    final value = callback(object);
    if (omitNull && value == null) {
      return null;
    }
    if (omitPredicate case final predicate? when predicate(object, value)) {
      return null;
    }
    return FieldValue<T, F>(name, value, false, null, printer);
  }

  @override
  bool isOmitted(T object) => evaluate(object) == null;

  @override
  void printOn(T object, StringBuffer buffer) =>
      printer.printOn(callback(object), buffer);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(callback, name: 'callback')
    ..addValue(omitNull, name: 'omitNull')
    ..addValue(omitPredicate, name: 'omitPredicate')
    ..addValue(printer, name: 'printer');
}
