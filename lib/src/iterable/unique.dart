part of iterable;

/**
 * Returns a lazy iterable that filters out duplicates from the [iterator].
 * If [equals] and [hashCode] are omitted, the iterator uses the objects'
 * intrinsic [Object.operator==] and [Object.hashCode] for comparison.
 *
 * The following expression iterates over 1, 2, 3, and 4:
 *
 *     unique([1, 2, 3, 2, 4])
 *
 */
Iterable/*<E>*/ unique(Iterable/*<E>*/ iterable, {bool equals(/*E*/ e1, /*E*/ e2),
                                                  int hashCode(/*E*/ e)}) {
  return new _UniqueIterable(iterable, equals, hashCode);
}

class _UniqueIterable<E> extends IterableBase<E> {

  final Iterable<E> _iterable;
  final Function _equals;
  final Function _hashCode;

  _UniqueIterable(this._iterable, this._equals, this._hashCode);

  @override
  Iterator<E> get iterator {
    var uniques = new HashSet(equals: _equals, hashCode: _hashCode);
    return _iterable.where((element) => uniques.add(element)).iterator;
  }

}