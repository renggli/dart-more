part of iterable;

/**
 * Returns a [Indexed] iterable
 *
 * By default the index is zero based, but an arbitrary [offset] can be provided.
 *
 * For example, the expression
 *
 *     indexed(['a', 'b'], offset: 1)
 *       .map((each) => '${each.value}-${each.index}')
 *       .join(', ');
 *
 * returns
 *
 *     'a-1, b-2'
 *
 */
Iterable<Indexed/*<E>*/> indexed(Iterable/*<E>*/ iterable, {int offset: 0}) {
  return new _IndexedIterable/*<E>*/(iterable, offset);
}

/**
 * An indexed value.
 */
class Indexed<E> {

  /**
   * The index of the value in the iterable.
   */
  final int index;

  /**
   * The actual value.
   */
  final E value;

  Indexed._(this.index, this.value);

  @override
  String toString() => '$index: $value';

}

class _IndexedIterable<E> extends IterableBase<Indexed<E>> {

  final Iterable<E> _iterable;
  final int _offset;

  _IndexedIterable(this._iterable, this._offset);

  @override
  Iterator<Indexed<E>> get iterator => new _IndexedIterator<E>(_iterable.iterator, _offset);

}

class _IndexedIterator<E> extends Iterator<Indexed<E>> {

  final Iterator<E> _iterable;

  int _index;

  _IndexedIterator(this._iterable, this._index);

  @override
  Indexed<E> current;

  @override
  bool moveNext() {
    if (_iterable.moveNext()) {
      current = new Indexed._(_index++, _iterable.current);
      return true;
    } else {
      current = null;
      return false;
    }
  }

}