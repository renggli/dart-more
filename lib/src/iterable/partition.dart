library more.iterable.partition;

/// Divides an `iterable` into sub-lists of a given `size`. The final list might
/// be smaller or equal the desired size.
///
/// The following expression yields [1, 2], [3, 4], [5]:
///
///     partition([1, 2, 3, 4, 5], 2);
///
Iterable<List<E>> partition<E>(Iterable<E> elements, int size) sync* {
  final iterator = elements.iterator;
  while (iterator.moveNext()) {
    final current = <E>[];
    do {
      current.add(iterator.current);
    } while (current.length < size && iterator.moveNext());
    yield current;
  }
}

/// Divides an `iterable` into sub-lists of a given `size`. The final list is
/// expanded with the provided `padding`.
///
/// The expression yields [1, 2], [3, 4], [5, -1]:
///
///     partition([1, 2, 3, 4, 5], 2, -1);
///
Iterable<Iterable<E>> partitionWithPadding<E>(Iterable<E> elements, int size,
    [E padding]) sync* {
  final iterator = elements.iterator;
  while (iterator.moveNext()) {
    final current = <E>[];
    do {
      current.add(iterator.current);
    } while (current.length < size && iterator.moveNext());
    while (current.length < size) {
      current.add(padding);
    }
    yield current;
  }
}
