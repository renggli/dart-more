import '../../../functional.dart';
import '../../../printer.dart';
import 'field.dart';

/// A field that is computed from a callback.
class FieldCallback<T, F> extends FieldPrinter<T> {
  FieldCallback(this.name, this.callback, this.omitNull, this.omitPredicate,
      this.printer);

  @override
  final String? name;
  final Map1<T, F> callback;
  final bool omitNull;
  final Predicate2<T, F>? omitPredicate;
  final Printer<F> printer;

  @override
  bool isOmitted(T object) {
    if (omitNull || omitPredicate != null) {
      final value = callback(object);
      if (omitNull && value == null) {
        return true;
      }
      if (omitPredicate != null && omitPredicate!(object, value)) {
        return true;
      }
    }
    return false;
  }

  @override
  void printOn(T object, StringBuffer buffer) =>
      printer.printOn(callback(object), buffer);
}
