import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

extension RepeatExtension<E> on Iterable<E> {
  /// Returns an infinite iterable with the elements of this iterable. If
  /// [count] is provided the resulting iterator is limited to [count]
  /// repetitions.
  ///
  /// Example expressions:
  ///
  ///    [1, 2].repeat();               // [1, 2, 1, 2, ...]
  ///    [1, 2, 3].repeat(count: 2);    // [1, 2, 3, 1, 2, 3]
  ///
  Iterable<E> repeat({int count}) {
    if (isEmpty || count == 0) {
      return const Iterable.empty();
    } else if (count == null) {
      return RepeatIterable(this);
    } else if (this is InfiniteIterable) {
      return this;
    }
    RangeError.checkNotNegative(count, 'count');
    return RepeatIterable(this).take(length * count);
  }
}

/// Returns an infinite iterable with a constant [element]. If [count] is
/// provided the resulting iterator is limited to [count] elements.
///
/// Example expressions:
///
///     repeat(2);               // [2, 2, 2, 2, 2, 2, ...]
///     repeat('a', count: 3);   // ['a', 'a', 'a']
///
Iterable<E> repeat<E>(E element, {int count}) => [element].repeat(count: count);

class RepeatIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  final Iterable<E> iterable;

  RepeatIterable(this.iterable);

  @override
  Iterator<E> get iterator => RepeatIterator<E>(iterable);
}

class RepeatIterator<E> extends Iterator<E> {
  final Iterable<E> iterable;
  Iterator<E> iterator;

  RepeatIterator(this.iterable) : iterator = iterable.iterator;

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
