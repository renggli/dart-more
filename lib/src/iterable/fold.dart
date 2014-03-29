part of iterable;

/**
 * Returns a lazy infinite list of repeated applications of the
 * n-ary [function] to its previous n initial [values].
 *
 * For example, the expression
 *
 *     fold([0, 1], (a, b) => a + b);
 *
 * results in the infinite iterable of all fibonacci numbers:
 *
 *     [0, 1, 1, 2, 3, 5, ...]
 *
 */
Iterable /* <E> */ fold(Iterable /* <E> */ values, Function combine) {
  return new _FoldIterable(values, combine);
}

class _FoldIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final Iterable<E> _values;
  final Function _combine;

  _FoldIterable(this._values, this._combine);

  @override
  Iterator<E> get iterator {
    return new _FoldIterator(new List.from(_values, growable: false), _combine);
  }

}

class _FoldIterator<E> extends Iterator<E> {

  final List<E> _state;
  final Function _combine;

  int _index = 0;
  E _current;

  _FoldIterator(this._state, this._combine);

  @override
  E get current => _current;

  @override
  bool moveNext() {
    if (_index < _state.length) {
      _current = _state[_index];
      _index++;
    } else {
      _current = Function.apply(_combine, _state);
      for (var i = 0; i < _state.length - 1; i++) {
        _state[i] = _state[i + 1];
      }
      _state[_state.length - 1] = _current;
    }
    return true;
  }

}