library more.ordering.natural;

import 'package:more/ordering.dart';

class NaturalOrdering<T> extends Ordering<T> {
  NaturalOrdering();

  @override
  int compare(T a, T b) => (a as Comparable).compareTo(b);

  @override
  Ordering<T> get reversed => ReverseNaturalOrdering<T>();
}

class ReverseNaturalOrdering<T> extends Ordering<T> {
  ReverseNaturalOrdering();

  @override
  int compare(T a, T b) => (b as Comparable).compareTo(a);

  @override
  Ordering<T> get reversed => NaturalOrdering<T>();
}
