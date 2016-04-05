part of more.ordering;

class _NaturalOrdering<T extends Comparable> extends Ordering<T> {
  const _NaturalOrdering();

  @override
  int compare(T a, T b) => a.compareTo(b);
}
