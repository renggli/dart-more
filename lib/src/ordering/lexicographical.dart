library more.ordering.lexicographical;

import 'package:more/ordering.dart';

class LexicographicalOrdering<T> extends Ordering<Iterable<T>> {
  final Ordering<T> ordering;

  const LexicographicalOrdering(this.ordering);

  @override
  int compare(Iterable<T> a, Iterable<T> b) {
    var ia = a.iterator,
        ib = b.iterator;
    while (ia.moveNext()) {
      if (!ib.moveNext()) {
        return 1;
      }
      var result = ordering.compare(ia.current, ib.current);
      if (result != 0) {
        return result;
      }
    }
    return ib.moveNext() ? -1 : 0;
  }
}
