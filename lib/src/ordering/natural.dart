library more.ordering.natural;

import 'package:more/ordering.dart';

class NaturalOrdering<T extends Comparable> extends Ordering<T> {
  const NaturalOrdering();

  @override
  int compare(T a, T b) => a.compareTo(b);

  @override
  Ordering<T> get reversed => const ReverseNaturalOrdering();
}

class ReverseNaturalOrdering<T extends Comparable> extends Ordering<T> {
  const ReverseNaturalOrdering();

  @override
  int compare(T a, T b) => b.compareTo(a);

  @override
  Ordering<T> get reversed => const NaturalOrdering();
}