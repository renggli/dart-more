import 'dart:collection';

import '../shared/exceptions.dart';

extension WindowStreamExtension<E> on Stream<E> {
  /// Sliding window [Stream] of given [size] over this [Stream].
  ///
  /// If the stream is of type [E], the returned stream will be of type
  /// `List<E>`.
  Stream<List<E>> window(int size,
      {int step = 1, bool includePartial = false}) async* {
    checkNonZeroPositive(size, 'size');
    checkNonZeroPositive(step, 'step');
    var index = 0;
    final current = ListQueue<E>(size);
    await for (final element in this) {
      while (current.length >= size) {
        current.removeFirst();
      }
      current.addLast(element);
      if (current.length == size) {
        if (index++ % step == 0) {
          yield current.toList(growable: false);
        }
      }
    }
    if (!includePartial || current.isEmpty) {
      return;
    }
    if (index == 0) {
      yield current.toList(growable: false);
      index++;
    }
    var reminder = step - (index - 1) % step;
    var rest = current.toList(growable: false);
    while (rest.length > reminder) {
      rest = rest.sublist(reminder);
      yield rest.toList(growable: false);
      reminder = step;
    }
  }
}
