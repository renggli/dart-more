extension ChunkedExtension<E> on Iterable<E> {
  /// Divides this [Iterable] into sub-lists of a given `size`. The final list
  /// might be smaller or equal to the desired size.
  ///
  /// The following expression yields [1, 2], [3, 4], [5]:
  ///
  ///     [1, 2, 3, 4, 5].chunked(2);
  ///
  Iterable<List<E>> chunked(int size) sync* {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final current = <E>[];
      do {
        current.add(iterator.current);
      } while (current.length < size && iterator.moveNext());
      yield current.toList(growable: false);
    }
  }

  /// Divides this [Iterable] into sub-lists of a given `size`. The final list
  /// is expanded with the provided `padding`, or `null`.
  ///
  /// The following expression yields [1, 2], [3, 4], [5, -1]:
  ///
  ///     [1, 2, 3, 4, 5].chunkedWithPadding(2, -1);
  ///
  Iterable<Iterable<E>> chunkedWithPadding(int size, E padding) sync* {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final current = <E>[];
      do {
        current.add(iterator.current);
      } while (current.length < size && iterator.moveNext());
      while (current.length < size) {
        current.add(padding);
      }
      yield current.toList(growable: false);
    }
  }
}
