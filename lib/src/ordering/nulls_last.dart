// ignore_for_file: deprecated_member_use_from_same_package

import '../../printer.dart';
import 'ordering.dart';

class NullsLastOrdering<T> extends Ordering<T?> {
  const NullsLastOrdering(this.ordering);

  final Ordering<T> ordering;

  @override
  int compare(T? a, T? b) {
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return 1;
    } else if (b == null) {
      return -1;
    }
    return ordering.compare(a, b);
  }

  @override
  Ordering<T?> get reversed => ordering.reversed.nullsFirst;

  @override
  Ordering<T?> get nullsFirst => ordering.nullsFirst;

  @override
  Ordering<T?> get nullsLast => this;

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(ordering, name: 'ordering');
}
