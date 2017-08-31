library more.ordering.nulls_first;

import 'package:more/ordering.dart';

class NullsFirstOrdering<T> extends Ordering<T> {
  final Ordering<T> ordering;

  const NullsFirstOrdering(this.ordering);

  @override
  int compare(T a, T b) {
    if (identical(a, b)) {
      return 0;
    } else if (identical(a, null)) {
      return -1;
    } else if (identical(b, null)) {
      return 1;
    } else {
      return ordering.compare(a, b);
    }
  }

  @override
  Ordering<T> get reversed => ordering.reversed.nullsLast;

  @override
  Ordering<T> get nullsFirst => this;

  @override
  Ordering<T> get nullsLast => ordering.nullsLast;
}
