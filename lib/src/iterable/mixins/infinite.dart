library more.iterable.mixins.infinite;

/// Mixin for infinitely sized iterables.
///
/// Intended to mix-in on top of `IterableBase<E>`.
abstract class InfiniteIterable<E> implements Iterable<E> {

  static T _throw<T>() => throw new UnsupportedError('Cannot perform on infite iterable');

  @override
  int get length => _throw();

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  E get last => _throw();

  @override
  E lastWhere(bool test(E element), {E orElse()}) => _throw();

  @override
  E get single => _throw();

  @override
  E singleWhere(bool test(E element)) => _throw();

  @override
  List<E> toList({bool growable: true}) => _throw();

  @override
  Set<E> toSet() => _throw();
}
