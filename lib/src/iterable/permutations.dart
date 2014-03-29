part of iterable;

/**
 * Returns an iterable over the lexographic permutations of [list] using
 * the optional [comparator].
 *
 * def permutations(iterable, r=None):
    # permutations('ABCD', 2) --> AB AC AD BA BC BD CA CB CD DA DB DC
    # permutations(range(3)) --> 012 021 102 120 201 210
    pool = tuple(iterable)
    n = len(pool)
    r = n if r is None else r
    if r > n:
        return
    indices = range(n)
    cycles = range(n, n-r, -1)
    yield tuple(pool[i] for i in indices[:r])
    while n:
        for i in reversed(range(r)):
            cycles[i] -= 1
            if cycles[i] == 0:
                indices[i:] = indices[i+1:] + indices[i:i+1]
                cycles[i] = n - i
            else:
                j = cycles[i]
                indices[i], indices[-j] = indices[-j], indices[i]
                yield tuple(pool[i] for i in indices[:r])
                break
        else:
            return
The code for permutations() can be also expressed as a subsequence of product(), filtered to exclude entries with repeated elements (those from the same position in the input pool):

def permutations(iterable, r=None):
    pool = tuple(iterable)
    n = len(pool)
    r = n if r is None else r
    for indices in product(range(n), repeat=r):
        if len(set(indices)) == r:
            yield tuple(pool[i] for i in indices)
The number of items returned is n! / (n-r)! when 0 <= r <= n or zero when r > n.

 *
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