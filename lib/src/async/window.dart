import 'dart:async' show StreamIterator;
import 'dart:collection';

import '../shared/exceptions.dart';

extension WindowStreamExtension<E> on Stream<E> {
  /// Sliding window [Stream] of given [size] over this [Stream].
  ///
  /// If the stream is of type [E], the returned stream will be of type
  /// `List<E>`.
  Stream<List<E>> window(
    int size, {
    int step = 1,
    bool includePartial = false,
  }) async* {
    checkNonZeroPositive(size, 'size');
    checkNonZeroPositive(step, 'step');
    final buffer = ListQueue<E>();
    final iterator = StreamIterator(this);
    while (true) {
      while (buffer.length < size && await iterator.moveNext()) {
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
          if (!await iterator.moveNext()) {
            return;
          }
        }
      }
    }
  }
}
