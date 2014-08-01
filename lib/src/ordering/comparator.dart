part of ordering;

class _ComparatorOrdering<T> extends Ordering<T> {

  final Comparator<T> _comparator;

  const _ComparatorOrdering(this._comparator);

  @override
  int compare(T a, T b) => _comparator(a, b);

}