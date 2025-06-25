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
    final buffer = ListQueue<E>();
    final iterator = this.iterator;
    while (true) {
      while (buffer.length < size && iterator.moveNext()) {
        buffer.addLast(iterator.current);
      }
      if (buffer.length < size) {
        if (includePartial && buffer.isNotEmpty) {
          yield buffer.toList(growable: false);
        }
        break;
      }
      yield buffer.toList(growable: false);
      if (step < size) {
        for (var i = 0; i < step; i++) {
          buffer.removeFirst();
        }
      } else {
        buffer.clear();
        for (var i = 0; i < step - size; i++) {
          if (!iterator.moveNext()) {
            return;
          }
        }
      }
    }
  }
}
