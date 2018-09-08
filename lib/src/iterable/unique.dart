library more.iterable.unique;

import 'dart:collection' show HashSet;

/// Returns a lazy iterable that filters out duplicates from the [Iterator].
/// If [equals] and [hashCode] are omitted, the iterator uses the objects'
/// intrinsic [Object.operator==] and [Object.hashCode] for comparison.
///
/// The following expression iterates over 1, 2, 3, and 4:
///
///     unique([1, 2, 3, 2, 4])
///
Iterable<E> unique<E>(Iterable<E> iterable,
    {bool equals(E e1, E e2), int hashCode(E e)}) sync* {
  final uniques = HashSet(equals: equals, hashCode: hashCode);
  for (var element in iterable) {
    if (uniques.add(element)) {
      yield element;
    }
  }
}
