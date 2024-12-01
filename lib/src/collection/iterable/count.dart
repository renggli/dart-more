extension CountIterableExtension<E> on Iterable<E> {
  /// Returns the number of time [predicate] evaluates to true.
  ///
  /// The following expression yields 2, because there are 2 odd numbers:
  ///
  /// ```dart
  /// [1, 2, 3].count((element) => element.isOdd);
  /// ```
  int count(bool Function(E element) predicate) => where(predicate).length;

  /// Returns the number of times [element] appears in the iterable.
  ///
  /// The following expression yields 2, because the number 5 appears
  /// twice:
  ///
  /// ```dart
  /// [1, 5, 4, 5, 2].occurrences(5);
  /// ```
  int occurrences(E element) => count((each) => each == element);
}
