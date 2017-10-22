library more.iterable.cycle;

import 'dart:collection' show IterableBase;

import 'package:more/src/iterable/mixins/infinite.dart';

/// Returns a iterable whose iterator cycles repeatedly over the elements
/// of an [iterable]. If [count] is specified, the returned iterable has a finite
/// size of [iterable] &times; [count]. If [count] is unspecified the returned
/// iterable is of infinite size.
///
/// For example, the expression
///
///     cycle([1, 2], 3)
///
/// results in the finite iterable:
///
///     [1, 2, 1, 2, 1, 2]
///
/// On the other hand, the expression
///
///     cycle([1, 2])
///
/// results in the infinite iterable:
///
///     [1, 2, 1, 2, ...]
///
Iterable<E> cycle<E>(Iterable<E> iterable, [int count]) {
  if (count == 0 || iterable.isEmpty) {
    return const Iterable<E>.empty();
  } else if (count == 1 || iterable is InfiniteIterable<E>) {
    return iterable;
  } else if (count == null) {
    return new InfiniteCycleIterable<E>(iterable);
  } else if (count > 1) {
    return new FiniteCycleIterable<E>(iterable, count);
  } else {
    throw new ArgumentError('Positive count expected, but got $count.');
  }
}

class InfiniteCycleIterable<E> extends IterableBase<E> with InfiniteIterable<E> {
  final Iterable<E> iterable;

  InfiniteCycleIterable(this.iterable);

  @override
  Iterator<E> get iterator => new InfiniteCycleIterator<E>(iterable);
}

class InfiniteCycleIterator<E> extends Iterator<E> {
  final Iterable<E> iterable;

  // ignore: prefer_const_constructors
  Iterator<E> iterator = new Iterable<E>.empty().iterator;

  InfiniteCycleIterator(this.iterable);

  @override
  E get current => iterator.current;

  @override
  bool moveNext() {
    if (!iterator.moveNext()) {
      iterator = iterable.iterator;
      iterator.moveNext();
    }
    return true;
  }
}

class FiniteCycleIterable<E> extends IterableBase<E> {
  final Iterable<E> iterable;
  final int count;

  FiniteCycleIterable(this.iterable, this.count);

  @override
  Iterator<E> get iterator => new FiniteCycleIterator<E>(iterable, count);
}

class FiniteCycleIterator<E> extends Iterator<E> {
  final Iterable<E> iterable;

  // ignore: prefer_const_constructors
  Iterator<E> iterator = new Iterable<E>.empty().iterator;
  bool completed = false;
  int count;

  FiniteCycleIterator(this.iterable, this.count);

  @override
  E get current => completed ? null : iterator.current;

  @override
  bool moveNext() {
    if (completed) {
      return false;
    }
    if (!iterator.moveNext()) {
      iterator = iterable.iterator;
      iterator.moveNext();
      if (--count < 0) {
        completed = true;
        return false;
      }
    }
    return true;
  }
}
