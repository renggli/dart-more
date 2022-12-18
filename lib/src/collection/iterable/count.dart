extension CountIterableExtension<E> on Iterable<E> {
  /// Returns the number of time [predicate] evaluates to true.
  ///
  /// The following expression yields 2, because there are 2 odd numbers:
  ///
  ///     [1, 2, 3].count((element) => element.isOdd);
  ///
  int count(bool Function(E element) predicate) => where(predicate).length;
}
