part of iterable;

/**
 * Mixin for infinitely sized iterables.
 *
 * Intended to mix-in on top of [IterableBase].
 */
abstract class InfiniteIterable<E> implements Iterable<E> {

  @override
  int get length {
    throw new StateError('Cannot return the length of an infinite iterable.');
  }

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  E get last {
    throw new StateError('Cannot return the last element of an infinite iterable.');
  }

  @override
  E lastWhere(bool test(E element), {E orElse()}) {
    throw new StateError('Cannot return the last element of an infinite iterable.');
  }

  @override
  E get single {
    throw new StateError('Cannot return the single element of an infinite iterable.');
  }

  @override
  E singleWhere(bool test(E element)) {
    throw new StateError('Cannot return the single element of an infinite iterable.');
  }

  @override
  List<E> toList({ bool growable: true }) {
    throw new StateError('Cannot convert an infinite iterable to a list.');
  }

  @override
  Set<E> toSet() {
    throw new StateError('Cannot convert an infinite iterable to a set.');
  }

}