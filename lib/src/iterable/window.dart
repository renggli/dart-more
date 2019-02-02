library more.iterable.window;

/// Sliding window of given `size` over an iterable.
///
/// The following expression yields [1, 2, 3], [2, 3, 4], [3, 4, 5]:
///
///     window([1, 2, 3, 4, 5], 2);
Iterable<List<E>> window<E>(Iterable<E> elements, int size,
    {int step = 1, bool includePartial = false}) sync* {
  if (size < 1) {
    throw RangeError.value(size, 'size', 'size must be positive');
  }
  if (step < 1) {
    throw RangeError.value(step, 'step', 'step must be positive');
  }
  final current = <E>[];
  final iterator = elements.iterator;
  for (;;) {
    while (current.length < size && iterator.moveNext()) {
      current.add(iterator.current);
    }
    if (current.length == size || (includePartial && current.isNotEmpty)) {
      yield current.toList(growable: false);
    } else {
      return;
    }
    if (step < size) {
      current.removeRange(0, step);
    } else {
      current.clear();
      for (var i = 0; i < step - size; i++) {
        if (!iterator.moveNext()) {
          return;
        }
      }
    }
  }
}
