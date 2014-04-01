part of iterable;

/**
 * Returns an infinite iterable with a constant [element]. If [count] is
 * provided the resulting iterator is limited to [count] elements.
 *
 * Example expressions:
 *
 *     repeat(2);        // [2, 2, 2, 2, 2, 2, ...]
 *     repeat('a', 3);   // ['a', 'a', 'a']
 *
 */
Iterable/*<E>*/ repeat(/*E*/ element, [int count]) {
  var iterable = new _RepeatIterable(element);
  return count == null ? iterable : iterable.take(count);
}

class _RepeatIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final E _element;

  _RepeatIterable(this._element);

  @override
  Iterator<E> get iterator => new _RepeatIterator(_element);

}

class _RepeatIterator<E> extends Iterator<E> {

  final E _element;

  E _current;

  _RepeatIterator(this._element);

  @override
  E get current => _current;

  @override
  bool moveNext() {
    _current = _element;
    return true;
  }

}