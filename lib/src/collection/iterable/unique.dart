import 'dart:collection' show HashSet;

extension UniqueIterableExtension<E> on Iterable<E> {
  /// Returns a lazy iterable that filters out duplicates from this [Iterator].
  /// If [equals] and [hashCode] are omitted, the iterator uses the objects'
  /// intrinsic [Object.operator==] and [Object.hashCode] for comparison.
  ///
  /// The following expression iterates over 1, 2, 3, and 4:
  ///
  ///     [1, 2, 3, 2, 4].unique()
  ///
  Iterable<E> unique(
      {bool Function(E e1, E e2)? equals, int Function(E e)? hashCode}) sync* {
    final uniques = HashSet(equals: equals, hashCode: hashCode);
    for (final element in this) {
      if (uniques.add(element)) {
        yield element;
      }
    }
  }
}
