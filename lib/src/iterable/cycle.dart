part of iterable;

/**
 * Returns an iterable whose iterator cycles indefinitely over the elements of
 * [iterable]. If [count] is provided the the iterations are limited to given
 * number of times.
 */
Iterable cycle(Iterable iterable, [int count]) {
  if (count == 0) {
    return empty();
  } else if (count == 1) {
    return iterable;
  } else if (count == null) {
    return new _InfiniteCycleIterable(iterable);
  } else if (count > 1) {
    return new _CountedCycleIterable(iterable, count);
  } else {
    throw new ArgumentException('Count needs to be positive, but got $count.');
  }
}

class _InfiniteCycleIterable<T> extends IterableBase<T> {

  final Iterable<T> _iterable;

  _InfiniteCycleIterable(this._iterable);

  @override
  Iterator<T> get iterator => _InfiniteCycleIterator(_iterable);

}

class _InfiniteCycleIterator<T> extends Iterator<T> {

  final Iterable<T> _iterable;
  Iterator<T> _iterator = const _EmptyIterator();

  _InfiniteCycleIterator(this._iterable);

  @override
  T get current => _iterator.current;

  @override
  bool moveNext() {
    if (_iterator.moveNext()) {
      _iterator = _iterable.iterator;
      _iterator.moveNext();
    }
    return true;
  }

}

class _CountedCycleIterable<T> extends IterableBase<T> {

  final Iterable<T> _iterable;
  final int _count;

  _CountedCycleIterable(this._iterable, this._count);

  @override
  Iterator<T> get iterator => _CountedCycleIterator(_iterable, _count);

}

class _CountedCycleIterator<T> extends Iterator<T> {

  final Iterable<T> _iterable;
  Iterator<T> _iterator = const _EmptyIterator();
  bool _running = true;
  int _count = 0;

  _CountedCycleIterator(this._iterable, this._count);

  @override
  T get current => _running ? _iterator.current : null;

  @override
  bool moveNext() {
    if (_running && _iterator.moveNext()) {
      if (_count > 0) {
        _iterator = _iterable.iterator();
        _iterator.moveNext();
        _count--;
      } else {
        _running = false;
      }
    }
    return _running;
  }

}