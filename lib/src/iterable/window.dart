library more.iterable.window;

/// Sliding window over an iterable.
///
/// The following expression yields [1, 2, 3], [2, 3, 4], [3, 4, 5]:
///
///     window([1, 2, 3, 4, 5], 2);
Iterable<List<E>> window<E>(Iterable<E> elements, int size) sync* {
  if (size < 1) {
    throw RangeError.value(size, 'size', 'window size must be positive');
  }
  final iterator = elements.iterator;
  final current = List.generate(
      size,
      (index) => iterator.moveNext()
          ? iterator.current
          : throw RangeError.index(index, elements, 'iterable'),
      growable: false);
  yield current.toList(growable: false);
  while (iterator.moveNext()) {
    current.setRange(0, size - 1, current, 1);
    current.last = iterator.current;
    yield current.toList(growable: false);
  }
}
