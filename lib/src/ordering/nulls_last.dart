part of more.ordering;

class _NullsLastOrdering<T> extends Ordering<T> {
  final Ordering<T> _ordering;

  const _NullsLastOrdering(this._ordering);

  @override
  int compare(T a, T b) {
    if (identical(a, b)) {
      return 0;
    } else if (identical(a, null)) {
      return 1;
    } else if (identical(b, null)) {
      return -1;
    } else {
      return _ordering.compare(a, b);
    }
  }
}
