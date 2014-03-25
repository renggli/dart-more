part of iterable;

/**
 * Returns a lazy infinite list of repeated applications of the
 * [function] to the [initial] value.
 *
 * For example, the expression
 *
 *     iterate(0, (n) => n + 1);
 *
 * results in the infinite list of all natural numbers:
 *
 *     [0, 1, 2, 3, 4, ...]
 *
 */
Iterable iterate(/* E */ initial, /* E */ function(/* E */ value)) {
  return new _IterateIterable(initial, function);
}

class _IterateIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final E _initial;
  final Function _function;

  _IterateIterable(this._initial, this._function);

  @override
  Iterator<E> get iterator => new _IterateIterator(_initial, _function);

}

class _IterateIterator<E> extends Iterator<E> {

  final Function _function;

  E _current;
  E _next;

  _IterateIterator(this._next, this._function);

  @override
  E get current => _current;

  @override
  bool moveNext() {
    _current = _next;
    _next = _function(_next);
    return true;
  }

}