import 'dart:collection';

extension WindowStreamExtension<E> on Stream<E> {
  /// Sliding window [Stream] of given `size` over this [Stream].
  ///
  /// If the stream is of type `E`, the returned stream
  /// will be of type `List<E>`.
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
