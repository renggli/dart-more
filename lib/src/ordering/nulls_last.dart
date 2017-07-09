library more.ordering.nulls_last;

import 'package:more/ordering.dart';

class NullsLastOrdering<T> extends Ordering<T> {
  final Ordering<T> ordering;

  const NullsLastOrdering(this.ordering);

  @override
  int compare(T a, T b) {
    if (identical(a, b)) {
      return 0;
    } else if (identical(a, null)) {
      return 1;
    } else if (identical(b, null)) {
      return -1;
    } else {
      return ordering.compare(a, b);
    }
  }
}
