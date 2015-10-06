part of more.ordering;

class _ExplicitOrdering<T> extends Ordering<T> {
  final Map<T, int> _ranking;

  const _ExplicitOrdering(this._ranking);

  @override
  int compare(T a, T b) => _rank(a) - _rank(b);

  int _rank(T element) {
    var rank = _ranking[element];
    if (rank == null) {
      throw new StateError('Unable to compare $element with $this');
    }
    return rank;
  }
}
