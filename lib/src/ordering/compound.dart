library more.ordering.compound;

import '../../ordering.dart';

class CompoundOrdering<T> extends Ordering<T> {
  final List<Ordering<T>> orderings;

  CompoundOrdering(Iterable<Ordering<T>> orderings)
      : orderings = List.of(orderings, growable: false);

  @override
  int compare(T a, T b) {
    for (final ordering in orderings) {
      final result = ordering.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }

  @override
  Ordering<T> compound(Ordering<T> other) =>
      CompoundOrdering([...orderings, other]);
}
