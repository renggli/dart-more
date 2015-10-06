part of more.ordering;

class _CompoundOrdering<T> extends Ordering<T> {
  final List<Ordering<T>> _orderings;

  const _CompoundOrdering(this._orderings);

  @override
  int compare(T a, T b) {
    for (var ordering in _orderings) {
      var result = ordering.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }

  @override
  Ordering<T> compound(Ordering<T> other) {
    var orderings = new List.from(_orderings)..add(other);
    return new _CompoundOrdering(new List.from(orderings, growable: false));
  }
}
