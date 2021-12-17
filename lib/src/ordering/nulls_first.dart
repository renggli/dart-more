import 'ordering.dart';

class NullsFirstOrdering<T> extends Ordering<T?> {
  const NullsFirstOrdering(this.ordering);

  final Ordering<T> ordering;

  @override
  int compare(T? a, T? b) {
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return -1;
    } else if (b == null) {
      return 1;
    }
    return ordering.compare(a, b);
  }

  @override
  Ordering<T?> get reversed => ordering.reversed.nullsLast;

  @override
  Ordering<T?> get nullsFirst => this;

  @override
  Ordering<T?> get nullsLast => ordering.nullsLast;
}
