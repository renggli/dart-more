import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

extension RepeatIterableExtension<E> on Iterable<E> {
  /// Returns an infinite iterable with the elements of this iterable. If
  /// [count] is provided the resulting iterator is limited to [count]
  /// repetitions.
  ///
  /// Example expressions:
  ///
  ///     [1, 2].repeat();               // [1, 2, 1, 2, ...]
  ///     [1, 2, 3].repeat(count: 2);    // [1, 2, 3, 1, 2, 3]
  ///
  Iterable<E> repeat({int? count}) {
    if (count == 0 || isEmpty) {
      return const [];
    } else if (count == 1 || this is InfiniteIterable) {
      return this;
    } else if (count == null) {
      return RepeatIterableIterable<E>(this);
    } else {
      RangeError.checkNotNegative(count, 'count');
      return RepeatIterableIterable<E>(this).take(count * length);
    }
  }
}

class RepeatIterableIterable<E> extends IterableBase<E>
    with InfiniteIterable<E> {
  RepeatIterableIterable(this.iterable);

  final Iterable<E> iterable;

  @override
  Iterator<E> get iterator => RepeatIterableIterator<E>(iterable);
}

class RepeatIterableIterator<E> implements Iterator<E> {
  RepeatIterableIterator(this.iterable) : iterator = iterable.iterator;

  final Iterable<E> iterable;
  Iterator<E> iterator;

  @override
  E get current => iterator.current;

  @override
  bool moveNext() {
    while (!iterator.moveNext()) {
      iterator = iterable.iterator;
    }
    return true;
  }
}
