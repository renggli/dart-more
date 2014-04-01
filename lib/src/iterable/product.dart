part of iterable;

/**
 * Returns an iterable over the cross product of [iterables].
 *
 * The resulting iterable is equivalent to nested for-loops. The rightmost elements
 * advance on every iteration. This pattern creates a lexicographic ordering so that
 * if the input’s iterables are sorted, the product is sorted as well.
 *
 * For example, the product of `['x', 'y']` and `[1, 2, 3]` is created with
 *
 *    product([['x', 'y'], [1, 2, 3]]);
 *
 * and results in an iterable with the following elements:
 *
 *    ['x', 1]
 *    ['x', 2]
 *    ['x', 3]
 *    ['y', 1]
 *    ['y', 2]
 *    ['y', 3]
 *
 */
Iterable<List/*<E>*/> product(Iterable<Iterable/*<E>*/> iterables) {
  if (iterables.isEmpty || iterables.any((iterable) => iterable.isEmpty)) {
    return empty();
  } else {
    return new _ProductIterable(iterables.map((iterable) {
      return iterable.toList(growable: false);
    }).toList(growable: false));
  }
}

class _ProductIterable<E> extends IterableBase<List<E>> {

  final List<List<E>> _sources;

  _ProductIterable(this._sources);

  @override
  Iterator<List<E>> get iterator {
    var state = new List.filled(_sources.length, 0);
    return new _ProductIterator(_sources, state);
  }

}

class _ProductIterator<E> extends Iterator<List<E>> {

  final List<List<E>> _sources;
  final List<int> _state;

  List _current = null;
  bool _completed = false;

  _ProductIterator(this._sources, this._state);

  @override
  List<E> get current => _current;

  @override
  bool moveNext() {
    if (_completed) {
      return false;
    }
    if (_current == null) {
      _current = new List.generate(_sources.length, (i) {
        return _sources[i][0];
      }, growable: false);
      return true;
    }
    for (var i = _state.length - 1; i >= 0; i--) {
      if (_state[i] + 1 < _sources[i].length) {
        _state[i]++;
        _current[i] = _sources[i][_state[i]];
        return true;
      } else {
        for (int j = _state.length - 1; j >= i; j--) {
          _state[j] = 0;
          _current[j] = _sources[j][0];
        }
      }
    }
    _completed = true;
    _current = null;
    return false;
  }

}