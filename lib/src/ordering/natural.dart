part of ordering;

class _NaturalOrdering<T> extends Ordering<T> {

  const _NaturalOrdering();

  @override
  int compare(a, b) => a.compareTo(b);

}
