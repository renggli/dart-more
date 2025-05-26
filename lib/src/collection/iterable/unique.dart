import 'dart:collection' show HashSet;

extension UniqueIterableExtension<E> on Iterable<E> {
  /// Returns a lazy iterable that filters out duplicates from this [Iterator].
  ///
  /// Duplicates are filtered out using a [Set] keeping track of the unique
  /// objects seen so far. If a [factory] is provided, it is used to create a
  /// new set instance. Otherwise a standard [HashSet] is created using
  /// [equals] and [hashCode], and if those are missing the iterator uses the
  /// objects' intrinsic [Object.operator==] and [Object.hashCode] for
  /// comparison.
  ///
  /// The following expression iterates over 1, 2, 3, and 4; skipping the second
  /// occurrence of 2:
  ///
  /// ```dart
  /// final input = [1, 2, 3, 2, 4];
  /// print(input.unique());  // [1, 2, 3, 4]
  /// ```
  Iterable<E> unique({
    Set<E> Function()? factory,
    bool Function(E e1, E e2)? equals,
    int Function(E e)? hashCode,
  }) sync* {
    final uniques = factory == null
        ? HashSet(equals: equals, hashCode: hashCode)
        : factory();
    for (final element in this) {
      if (uniques.add(element)) {
        yield element;
      }
    }
  }
}
