library more.ordering.reverse;

import 'package:more/ordering.dart';

class ReverseOrdering<T> extends Ordering<T> {
  final Ordering<T> ordering;

  const ReverseOrdering(this.ordering);

  @override
  int compare(T a, T b) => ordering.compare(b, a);

  @override
  Ordering<T> get reversed => ordering;
}
