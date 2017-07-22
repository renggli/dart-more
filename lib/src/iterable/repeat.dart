library more.iterable.repeat;

import 'dart:collection';

import 'package:more/src/iterable/mixins/infinite.dart';

/// Returns an infinite iterable with a constant [element]. If [count] is
/// provided the resulting iterator is limited to [count] elements.
///
/// Example expressions:
///
///     repeat(2);        // [2, 2, 2, 2, 2, 2, ...]
///     repeat('a', 3);   // ['a', 'a', 'a']
///
Iterable<E> repeat<E>(E element, [int count]) {
  var iterable = new RepeatIterable<E>(element);
  return count == null ? iterable : iterable.take(count);
}

class RepeatIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  final E element;

  RepeatIterable(this.element);

  @override
  Iterator<E> get iterator => new RepeatIterator<E>(element);
}

class RepeatIterator<E> extends Iterator<E> {
  final E element;

  RepeatIterator(this.element);

  @override
  E current;

  @override
  bool moveNext() {
    current = element;
    return true;
  }
}
