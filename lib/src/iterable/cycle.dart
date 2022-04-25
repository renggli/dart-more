import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

extension CycleExtension<E> on Iterable<E> {
  /// Returns a iterable whose iterator cycles repeatedly over the elements
  /// of this [Iterable]. If [count] is specified, the returned iterable has a
  /// finite size of this [Iterable] &times; [count]. If [count] is unspecified
  /// the returned iterable is of infinite size.
  ///
  /// For example, the expression
  ///
  ///     [1, 2].cycle(count: 3)
  ///
  /// results in the finite iterable:
  ///
  ///     [1, 2, 1, 2, 1, 2]
  ///
  /// On the other hand, the expression
  ///
  ///     [1, 2].cycle()
  ///
  /// results in the infinite iterable:
  ///
  ///     [1, 2, 1, 2, ...]
  ///
  Iterable<E> cycle([int? count]) {
    if (count == 0 || isEmpty) {
      return const Iterable.empty();
    } else if (count == 1 || this is InfiniteIterable<E>) {
      return this;
    } else if (count == null) {
      return InfiniteCycleIterable<E>(this);
    } else if (count > 1) {
      return FiniteCycleIterable<E>(this, count);
    } else {
      throw ArgumentError.value(count, 'count', 'Expected positive count');
    }
  }
}

class InfiniteCycleIterable<E> extends IterableBase<E>
    with InfiniteIterable<E> {
  InfiniteCycleIterable(this.iterable);

  final Iterable<E> iterable;

  @override
  Iterator<E> get iterator => InfiniteCycleIterator<E>(iterable);
}

class InfiniteCycleIterator<E> extends Iterator<E> {
  InfiniteCycleIterator(this.iterable);

  final Iterable<E> iterable;

  Iterator<E> iterator = Iterable<E>.empty().iterator;

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
  FiniteCycleIterable(this.iterable, this.count);

  final Iterable<E> iterable;
  final int count;

  @override
  Iterator<E> get iterator => FiniteCycleIterator<E>(iterable, count);
}

class FiniteCycleIterator<E> extends Iterator<E> {
  FiniteCycleIterator(this.iterable, this.count);

  final Iterable<E> iterable;

  Iterator<E> iterator = Iterable<E>.empty().iterator;
  bool completed = false;
  int count;

  @override
  E get current => iterator.current;

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
