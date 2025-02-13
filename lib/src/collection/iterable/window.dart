import 'dart:collection';

import '../../shared/exceptions.dart';

extension WindowIterableExtension<E> on Iterable<E> {
  /// Sliding window of given [size] over this [Iterable].
  ///
  /// The following expression yields `[1, 2, 3]`, `[2, 3, 4]`, and `[3, 4, 5]`:
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].window(3);
  /// ```
  Iterable<List<E>> window(
    int size, {
    int step = 1,
    bool includePartial = false,
  }) sync* {
    checkNonZeroPositive(size, 'size');
    checkNonZeroPositive(step, 'step');
    final current = ListQueue<E>(size);
    final iterator = this.iterator;
    for (;;) {
      while (current.length < size && iterator.moveNext()) {
        current.addLast(iterator.current);
      }
      if (current.length == size || (includePartial && current.isNotEmpty)) {
        yield current.toList(growable: false);
      } else {
        return;
      }
      if (step < size) {
        for (var i = 0; i < step; i++) {
          current.removeFirst();
        }
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
