import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

/// Returns an infinite iterable with a constant [element]. If [count] is
/// provided the resulting iterator is limited to [count] elements.
///
/// For example:
///
/// ```dart
/// repeat(2);               // [2, 2, 2, 2, 2, 2, ...]
/// repeat('a', count: 3);   // ['a', 'a', 'a']
/// ```
Iterable<E> repeat<E>(E element, {int? count}) {
  if (count == 0) {
    return const [];
  } else if (count == null) {
    return RepeatElementIterable<E>(element);
  } else {
    RangeError.checkNotNegative(count, 'count');
    return RepeatElementIterable<E>(element).take(count);
  }
}

class RepeatElementIterable<E> extends IterableBase<E>
    with InfiniteIterable<E> {
  RepeatElementIterable(this.element);

  final E element;

  @override
  Iterator<E> get iterator => RepeatElementIterator<E>(element);
}

class RepeatElementIterator<E> implements Iterator<E> {
  RepeatElementIterator(this.current);

  @override
  final E current;

  @override
  bool moveNext() => true;
}
