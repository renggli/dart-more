part of ordering;

class _LexicographicalOrdering<T> extends Ordering<Iterable<T>> {
  final Ordering<T> _other;

  const _LexicographicalOrdering(this._other);

  @override
  int compare(Iterable<T> a, Iterable<T> b) {
    var ia = a.iterator,
        ib = b.iterator;
    while (ia.moveNext()) {
      if (!ib.moveNext()) {
        return 1;
      }
      var result = _other.compare(ia.current, ib.current);
      if (result != 0) {
        return result;
      }
    }
    return ib.moveNext() ? -1 : 0;
  }
}
