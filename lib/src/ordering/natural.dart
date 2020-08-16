import '../../ordering.dart';

class NaturalOrdering<T extends Comparable<T>> extends Ordering<T> {
  const NaturalOrdering();

  @override
  int compare(T a, T b) => a.compareTo(b);

  @override
  Ordering<T> get reversed => ReverseNaturalOrdering<T>();
}

class ReverseNaturalOrdering<T extends Comparable<T>> extends Ordering<T> {
  const ReverseNaturalOrdering();

  @override
  int compare(T a, T b) => b.compareTo(a);

  @override
  Ordering<T> get reversed => NaturalOrdering<T>();
}
