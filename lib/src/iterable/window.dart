library more.iterable.window;

/// Sliding window over an iterable.
///
/// The following expression yields [1, 2, 3], [2, 3, 4], [3, 4, 5]:
///
///     window([1, 2, 3, 4, 5], 2);
Iterable<List<E>> window<E>(Iterable<E> elements, int size) sync* {
  final iterator = elements.iterator;
  final result = List.generate<E>(
      size,
      (index) => iterator.moveNext()
          ? iterator.current
          : throw RangeError.index(index, elements, 'iterable'),
      growable: false);
  yield result;
  while (iterator.moveNext()) {
    result.setRange(0, size - 1, result, 1);
    result.last = iterator.current;
    yield result;
  }
}
