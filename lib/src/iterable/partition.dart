library more.iterable.partition;

/// Divides an `iterable` into sub-iterables of a given `size`. The final
/// iterable might be smaller or equal the desired size.
///
/// The following expression yields [1, 2], [3, 4], [5]:
///
///     partition([1, 2, 3, 4, 5], 2);
Iterable<List<E>> partition<E>(Iterable<E> elements, int size) sync* {
  final current = <E>[];
  final iterator = elements.iterator;
  while (iterator.moveNext()) {
    do {
      current.add(iterator.current);
    } while (current.length < size && iterator.moveNext());
    yield current;
    current.clear();
  }
}

/// Divides an `iterable` into sub-iterables of a given `size`. The final
/// iterable is expanded with the provided `padding`.
///
/// The expression yields [1, 2], [3, 4], [5, -1]:
///
///     partition([1, 2, 3, 4, 5], 2, -1);
Iterable<Iterable<E>> partitionWithPadding<E>(Iterable<E> elements, int size,
    [E padding]) sync* {
  final current = <E>[];
  final iterator = elements.iterator;
  while (iterator.moveNext()) {
    do {
      current.add(iterator.current);
    } while (current.length < size && iterator.moveNext());
    while (current.length < size) {
      current.add(padding);
    }
    yield current;
    current.clear();
  }
}
