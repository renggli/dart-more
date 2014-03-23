part of iterable;

/**
 * Returns an iterable over the lexographic permutations of [list] using
 * the optional [comparator].
 */
Iterable<List> permutations(List list, [Comparator comparator]) {
  return new _PermutationIterable(list, comparator != null
      ? comparator : Comparable.compare);
}

class _PermutationIterable extends IterableBase<List> {

  final List _list;
  final Comparator _comparator;

  _PermutationIterable(this._list, this._comparator);

  @override
  Iterator<List> get iterator {
    return new _PermutationIterator(_list, _comparator);
  }

}

class _PermutationIterator extends Iterator<List> {

  final List _list;
  final Comparator _comparator;
  List _current;
  bool _completed = false;

  _PermutationIterator(this._list, this._comparator);

  @override
  List get current => _current;

  @override
  bool moveNext() {
    if (_completed) {
      return false;
    } else if (_current == null) {
      _current = new List.from(_list, growable: false);
      return true;
    }
    var k = _current.length - 2;
    while (k >= 0 && _comparator(_current[k], _current[k + 1]) >= 0) {
      k--;
    }
    if (k == -1) {
      _completed = true;
      _current = null;
      return false;
    }
    var l = _current.length - 1;
    while (_comparator(_current[k], _current[l]) >= 0) {
      l--;
    }
    _swap(k, l);
    for (var i = k + 1, j = _current.length - 1; i < j; i++, j--) {
      _swap(i, j);
    }
    return true;
  }

  void _swap(int i, int j) {
    var temp = _current[i];
    _current[i] = _current[j];
    _current[j] = temp;
  }

}