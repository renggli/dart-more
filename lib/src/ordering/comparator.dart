library more.ordering.comparator;

import '../../ordering.dart';

class ComparatorOrdering<T> extends Ordering<T> {
  final Comparator<T> comparator;

  const ComparatorOrdering(this.comparator);

  @override
  int compare(T a, T b) => comparator(a, b);
}
