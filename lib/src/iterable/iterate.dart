import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

/// One argument function returning an object of the same type.
typedef IterateCallback<E> = E Function(E value);

/// Returns a lazy infinite list of repeated applications of the [function] to
/// the initial [value].
///
/// For example, the expression
///
///     iterate(0, (n) => n + 1);
///
/// results in the infinite iterable of all natural numbers:
///
///     [0, 1, 2, 3, 4, ...]
///
Iterable<E> iterate<E>(E value, IterateCallback<E> function) =>
    IterateIterable<E>(value, function);

class IterateIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  final E value;
  final IterateCallback<E> function;

  IterateIterable(this.value, this.function);

  @override
  Iterator<E> get iterator => IterateIterator<E>(value, function);
}

class IterateIterator<E> extends Iterator<E> {
  final IterateCallback<E> function;

  E next;

  IterateIterator(this.next, this.function);

  @override
  late E current;

  @override
  bool moveNext() {
    current = next;
    next = function(next);
    return true;
  }
}
