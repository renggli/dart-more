library more.ordering.comparator;

import 'package:more/ordering.dart';

class ComparatorOrdering<T> extends Ordering<T> {
  final Comparator<T> _comparator;

  const ComparatorOrdering(this._comparator);

  @override
  int compare(T a, T b) => _comparator(a, b);
}
