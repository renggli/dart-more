/// Mixin for infinitely sized iterables.
///
/// Intended to mix-in on top of `IterableBase<E>`.
mixin InfiniteIterable<E> on Iterable<E> {
  static Never _throw() =>
      throw UnsupportedError('Cannot perform operation on infinite iterable');

  @override
  int get length => _throw();

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  E get last => _throw();

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _throw();

  @override
  E get single => _throw();

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _throw();

  @override
  List<E> toList({bool growable = true}) => _throw();

  @override
  Set<E> toSet() => _throw();
}
