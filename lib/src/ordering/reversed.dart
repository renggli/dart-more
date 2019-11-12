library more.ordering.reversed;

import '../../ordering.dart';

class ReversedOrdering<T> extends Ordering<T> {
  final Ordering<T> ordering;

  const ReversedOrdering(this.ordering);

  @override
  int compare(T a, T b) => ordering.compare(b, a);

  @override
  Ordering<T> get reversed => ordering;
}
