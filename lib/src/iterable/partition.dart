library more.iterable.partition;

/// Divides an `iterable` into sub-iterables of a given `size`. The final
/// iterable might be smaller or equal the desired size.
///
/// The following expression yields [1, 2], [3, 4], [5]:
///
///     partition([1, 2, 3, 4, 5], 2);
Iterable<List<E>> partition<E>(Iterable<E> elements, int size) sync* {
  final result = <E>[];
  final iterator = elements.iterator;
  while (iterator.moveNext()) {
    do {
      result.add(iterator.current);
    } while (result.length < size && iterator.moveNext());
    yield result;
    result.clear();
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
  final result = <E>[];
  final iterator = elements.iterator;
  while (iterator.moveNext()) {
    do {
      result.add(iterator.current);
    } while (result.length < size && iterator.moveNext());
    while (result.length < size) {
      result.add(padding);
    }
    yield result;
    result.clear();
  }
}
