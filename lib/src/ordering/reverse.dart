part of ordering;

class _ReverseOrdering<T> extends Ordering<T> {

  final Ordering<T> _other;

  const _ReverseOrdering(this._other);

  @override
  int compare(T a, T b) => _other.compare(b, a);

  @override
  Ordering<T> reverse() => _other;

}