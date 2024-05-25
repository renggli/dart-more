import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

/// Returns a lazy infinite list of repeated applications of [callback] to the
/// initial [value].
///
/// For example, the following expression results in an infinite iterable of all
/// natural numbers `[0, 1, 2, 3, 4, ...]`:
///
/// ```dart
/// iterate(0, (n) => n + 1);
/// ```
Iterable<E> iterate<E>(E value, E Function(E element) callback) =>
    IterateIterable<E>(value, callback);

class IterateIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  IterateIterable(this.value, this.function);

  final E value;
  final E Function(E element) function;

  @override
  Iterator<E> get iterator => IterateIterator<E>(value, function);
}

class IterateIterator<E> implements Iterator<E> {
  IterateIterator(this.next, this.function) : current = next;

  final E Function(E element) function;
  E next;

  @override
  E current;

  @override
  bool moveNext() {
    current = next;
    next = function(next);
    return true;
  }
}
