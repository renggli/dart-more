import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

/// Extension on [Iterable] to repeat its elements.
extension RepeatIterableExtension<E> on Iterable<E> {
  /// Returns an infinite iterable with the elements of this iterable. If
  /// [count] is provided the resulting iterator is limited to [count]
  /// repetitions.
  ///
  /// For example:
  ///
  /// ```dart
  /// [1, 2].repeat();               // [1, 2, 1, 2, ...]
  /// [1, 2, 3].repeat(count: 2);    // [1, 2, 3, 1, 2, 3]
  /// ```
  Iterable<E> repeat({int? count}) {
    if (count != null) {
      RangeError.checkNotNegative(count, 'count');
    }
    if (count == 0 || isEmpty) {
      return const [];
    } else if (count == 1 || this is InfiniteIterable) {
      return this;
    } else if (count == null) {
      return RepeatInfiniteIterable<E>(this);
    } else {
      return RepeatCountIterable<E>(this, count);
    }
  }
}

class RepeatInfiniteIterable<E> extends IterableBase<E>
    with InfiniteIterable<E> {
  new(this.iterable);

  final Iterable<E> iterable;

  @override
  Iterator<E> get iterator => RepeatIterableIterator<E>(iterable, null);
}

class RepeatCountIterable<E> extends IterableBase<E> {
  new(this.iterable, this.count);

  final Iterable<E> iterable;
  final int count;

  @override
  Iterator<E> get iterator => RepeatIterableIterator<E>(iterable, count);
}

class RepeatIterableIterator<E> implements Iterator<E> {
  new(this.iterable, this.remainingRepetitions)
    : iterator = iterable.iterator,
      hasElements = false;

  final Iterable<E> iterable;
  int? remainingRepetitions;
  Iterator<E> iterator;
  bool hasElements;

  @override
  E get current => iterator.current;

  @override
  bool moveNext() {
    if (remainingRepetitions != null && remainingRepetitions! <= 0) {
      return false;
    }
    while (!iterator.moveNext()) {
      if (remainingRepetitions != null) {
        remainingRepetitions = remainingRepetitions! - 1;
        if (remainingRepetitions! <= 0) return false;
      }
      iterator = iterable.iterator;
      if (!iterator.moveNext()) {
        return false;
      }
      return true;
    }
    return true;
  }
}
