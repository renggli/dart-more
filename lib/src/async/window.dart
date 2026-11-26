import 'dart:async' show StreamIterator;
import 'dart:collection';

import '../shared/exceptions.dart';

/// Extension on [Stream] providing sliding window operations.
extension WindowStreamExtension<E> on Stream<E> {
  /// Returns a sliding window [Stream] of given [size] over this [Stream].
  ///
  /// The [step] parameter specifies the number of elements to advance between
  /// consecutive windows (defaults to `1`). If [includePartial] is `true`,
  /// trailing windows smaller than [size] are included at the end of the
  /// stream.
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
    try {
      while (true) {
        while (buffer.length < size && await iterator.moveNext()) {
          buffer.addLast(iterator.current);
        }
        if (buffer.length < size) {
          if (includePartial) {
            while (buffer.isNotEmpty) {
              yield buffer.toList(growable: false);
              if (buffer.length <= step) break;
              for (var i = 0; i < step; i++) {
                buffer.removeFirst();
              }
            }
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
    } finally {
      await iterator.cancel();
    }
  }
}
