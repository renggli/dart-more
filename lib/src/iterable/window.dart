import 'dart:collection';

extension WindowExtension<E> on Iterable<E> {
  /// Sliding window of given `size` over this [Iterable].
  ///
  /// The following expression yields [1, 2, 3], [2, 3, 4], [3, 4, 5]:
  ///
  ///     [1, 2, 3, 4, 5].window(2);
  ///
  Iterable<List<E>> window(int size,
      {int step = 1, bool includePartial = false}) sync* {
    if (size < 1) {
      throw RangeError.value(size, 'size', 'size must be positive');
    }
    if (step < 1) {
      throw RangeError.value(step, 'step', 'step must be positive');
    }
    final current = <E>[];
    final iterator = this.iterator;
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
}

extension WindowStreamExtension<E> on Stream<E> {
  Stream<List<E>> window(int size,
      {int step = 1, bool includePartial = false}) async* {
    if (size < 1) {
      throw RangeError.value(size, 'size', 'size must be positive');
    }
    if (step < 1) {
      throw RangeError.value(step, 'step', 'step must be positive');
    }
    int idx = 0; // to calculate step
    final memory = ListQueue<E>(size);
    await for (var elem in this) {
      if (memory.length >= size) memory.removeFirst();
      memory.addLast(elem);
      if (memory.length == size) {
        if (idx++ % step == 0) yield memory.toList(growable: false);
      }
    }

    if (!includePartial || memory.isEmpty) return;

    // first partial
    if (idx == 0) {
      yield memory.toList(growable: false);
      idx++;
    }

    var rem = step - (idx - 1) % step;
    var rest = memory.toList(growable: false);
    while (rest.length > rem) {
      rest = rest.sublist(rem);
      yield rest.toList(growable: false);
      rem = step;
    }
  }
}
