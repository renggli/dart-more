library more.iterable.empty;

/// Returns an efficient empty iterable.
///
/// Deprecated, use `new Iterable.empty()` instead.
@deprecated
Iterable<E> empty<E>() => emptyIterable<E>();

/// Returns an efficient empty iterable.
///
/// For example, the expression
///
///     empty()
///
/// results in the empty iterable:
///
///     []
///
/// Deprecated, use `new Iterable.empty()` instead.
@deprecated
Iterable<E> emptyIterable<E>() {
  return new Iterable.empty();
}

/// Returns an efficient empty iterator.
///
/// For example, the expression
///
///     emptyIterator()
///
/// results in the empty iterator:
///
///     []
///
Iterator<E> emptyIterator<E>() {
  // const constructors expect concrete types
  return const _EmptyIterator<E>();
}

class _EmptyIterator<E> implements Iterator<E> {
  const _EmptyIterator();

  @override
  E get current => null;

  @override
  bool moveNext() => false;
}
