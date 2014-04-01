part of iterable;

/**
 * Returns a iterable whose iterator cycles repeatedly over the elements
 * of an [iterable]. If [count] is specified, the returned iterable has a finite
 * size of [iterable] &times; [count]. If [count] is unspecified the returned
 * iterable is of infinite size.
 *
 * For example, the expression
 *
 *     cycle([1, 2], 3)
 *
 * results in the finite iterable:
 *
 *     [1, 2, 1, 2, 1, 2]
 *
 * On the other hand, the expression
 *
 *     cycle([1, 2])
 *
 * results in the infinite iterable:
 *
 *     [1, 2, 1, 2, ...]
 *
 */
Iterable/*<E>*/ cycle(Iterable/*<E>*/ iterable, [int count = null]) {
  if (count == 0 || iterable.isEmpty) {
    return empty();
  } else if (count == 1 || iterable is InfiniteIterable) {
    return iterable;
  } else if (count == null) {
    return new _InfiniteCycleIterable(iterable);
  } else if (count > 1) {
    return new _FiniteCycleIterable(iterable, count);
  } else {
    throw new ArgumentError('Positive count expected, but got $count.');
  }
}

class _InfiniteCycleIterable<E> extends IterableBase<E> with InfiniteIterable<E> {

  final Iterable<E> _iterable;

  _InfiniteCycleIterable(this._iterable);

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

class _FiniteCycleIterable<E> extends IterableBase<E> {

  final Iterable<E> _iterable;
  final int _count;

  _FiniteCycleIterable(this._iterable, this._count);

  @override
  Iterator<E> get iterator => new _FiniteCycleIterator(_iterable, _count);

}

class _FiniteCycleIterator<E> extends Iterator<E> {

  final Iterable<E> _iterable;

  Iterator<E> _iterator = const _EmptyIterator();
  bool _completed = false;
  int _count = 0;

  _FiniteCycleIterator(this._iterable, this._count);

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