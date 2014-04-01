part of iterable;

/**
 * Returns a lazy infinite list of repeated applications of the
 * [function] to the initial [value].
 *
 * For example, the expression
 *
 *     iterate(0, (n) => n + 1);
 *
 * results in the infinite iterable of all natural numbers:
 *
 *     [0, 1, 2, 3, 4, ...]
 *
 */
Iterable/*<E>*/ iterate(/*E*/ value, /*E*/ function(/*E*/ value)) {
  return new _IterateIterable(value, function);
}

class _IterateIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final E _value;
  final Function _function;

  _IterateIterable(this._value, this._function);

  @override
  Iterator<E> get iterator => new _IterateIterator(_value, _function);

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