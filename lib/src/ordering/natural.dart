library more.ordering.natural;

import 'package:more/ordering.dart';

class NaturalOrdering<T extends Comparable> extends Ordering<T> {
  const NaturalOrdering();

  @override
  int compare(T a, T b) => a.compareTo(b);
}
