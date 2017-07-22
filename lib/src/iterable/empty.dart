library more.iterable.empty;

/// Returns an efficient empty iterable.
///
/// Deprecated, use `const Iterable<E>.empty()` instead.
@deprecated
Iterable<E> empty<E>() {
  return const Iterable<E>.empty();
}

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
/// Deprecated, use `const Iterable<E>.empty()` instead.
@deprecated
Iterable<E> emptyIterable<E>() {
  return const Iterable<E>.empty();
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
/// Deprecated, use `const Iterable<E>.empty().iterator` instead.
@deprecated
Iterator<E> emptyIterator<E>() {
  return const Iterable<E>.empty().iterator;
}
