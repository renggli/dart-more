part of iterable;

/**
 * Returns an iterable whose iterator cycles [count] times over the elements
 * of [iterable]. If the [count] is not specified an iterable that cycles
 * indefinitely is returned.
 */
Iterable cycle(Iterable iterable, [num count = double.INFINITY]) {
  if (count == 0 || iterable.isEmpty) {
    return empty();
  } else if (count == 1) {
    return iterable;
  } else if (count.isInfinite) {
    return new _InfiniteCycleIterable(iterable);
  } else if (count > 1) {
    return new _CountedCycleIterable(iterable, count);
  } else {
    throw new ArgumentError('Positive count expected, but got $count.');
  }
}

class _InfiniteCycleIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final Iterable<E> _iterable;

  _InfiniteCycleIterable(this._iterable);

  @override
  bool get isEmpty => false;

  @override
  int get length => throw new StateError('Infinite iterable');

  @override
  Iterator<E> get iterator => new _InfiniteCycleIterator(_iterable);

}

class _InfiniteCycleIterator<E> extends Iterator<E> {

  final Iterable<E> _iterable;

  Iterator<E> _iterator = const _EmptyIterator();

  _InfiniteCycleIterator(this._iterable);

  @override
  E get current => _iterator.current;

  @override
  bool moveNext() {
    if (!_iterator.moveNext()) {
      _iterator = _iterable.iterator;
      _iterator.moveNext();
    }
    return true;
  }

}

class _CountedCycleIterable<E> extends IterableBase<E> {

  final Iterable<E> _iterable;
  final int _count;

  _CountedCycleIterable(this._iterable, this._count);

  @override
  Iterator<E> get iterator => new _CountedCycleIterator(_iterable, _count);

}

class _CountedCycleIterator<E> extends Iterator<E> {

  final Iterable<E> _iterable;

  Iterator<E> _iterator = const _EmptyIterator();
  bool _completed = false;
  int _count = 0;

  _CountedCycleIterator(this._iterable, this._count);

  @override
  E get current => _completed ? null : _iterator.current;

  @override
  bool moveNext() {
    if (_completed) {
      return false;
    }
    if (!_iterator.moveNext()) {
      _iterator = _iterable.iterator;
      _iterator.moveNext();
      if (--_count < 0) {
        _completed = true;
        return false;
      }
    }
    return true;
  }

}