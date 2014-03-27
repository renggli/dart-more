part of iterable;

/**
 * Returns a lazy infinite list with a constant [value].
 *
 * For example, the expression
 *
 *     repeat(1);
 *
 * results in the infinite list:
 *
 *     [1, 1, 1, 1, 1, ...]
 *
 */
Iterable repeat(/* E */ value) {
  return new _RepeatIterable(value);
}

class _RepeatIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final E _value;

  _RepeatIterable(this._value);

  @override
  Iterator<E> get iterator => new _RepeatIterator(_value);

}

class _RepeatIterator<E> extends Iterator<E> {

  final E _value;

  E _current;

  _RepeatIterator(this._value);

  @override
  E get current => _current;

  @override
  bool moveNext() {
    _current = _value;
    return true;
  }

}