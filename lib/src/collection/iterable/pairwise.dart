extension PairwiseIterableExtension<E> on Iterable<E> {
  /// An iterable over the successive overlapping pairs of this iterable.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = [1, 2, 3, 4];
  /// print(input.pairwise());  // [(1, 2), (2, 3), (3, 4)]
  /// ```
  Iterable<(E, E)> pairwise() sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    var previous = iterator.current;
    while (iterator.moveNext()) {
      final current = iterator.current;
      yield (previous, current);
      previous = current;
    }
  }
}
