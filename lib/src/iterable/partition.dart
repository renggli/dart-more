library more.iterable.partition;

import 'dart:collection' show IterableBase;

/// Divides an `iterable` into sub-iterables of a given `size`. The final
/// iterable might be smaller or equal the desired size.
///
/// The following expression yields [1, 2], [3, 4], [5]:
///
///     partition([1, 2, 3, 4, 5], 2);
Iterable<Iterable<E>> partition<E>(Iterable<E> elements, int size) {
  return new PartitionIterable<E>(elements, size);
}

class PartitionIterable<E> extends IterableBase<Iterable<E>> {
  final Iterable<E> elements;
  final int size;

  PartitionIterable(this.elements, this.size);

  @override
  Iterator<Iterable<E>> get iterator =>
      new PartitionIterator<E>(elements.iterator, size);
}

class PartitionIterator<E> extends Iterator<Iterable<E>> {
  final Iterator<E> iterator;
  final int size;

  bool completed = false;

  PartitionIterator(this.iterator, this.size);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      current = null;
      return false;
    } else {
      current = <E>[];
      for (var i = 0; i < size; i++) {
        if (iterator.moveNext()) {
          current.add(iterator.current);
        } else {
          completed = true;
          if (current.isEmpty) {
            current = null;
            return false;
          }
          return true;
        }
      }
    }
    return true;
  }
}

/// Divides an `iterable` into sub-iterables of a given `size`. The final
/// iterable is expanded with the provided `padding`.
///
/// The expression yields [1, 2], [3, 4], [5, -1]:
///
///     partition([1, 2, 3, 4, 5], 2, -1);
Iterable<Iterable<E>> partitionWithPadding<E>(Iterable<E> elements, int size,
    [E padding]) {
  return new PartitionWithPaddingIterable<E>(elements, size, padding);
}

class PartitionWithPaddingIterable<E> extends IterableBase<Iterable<E>> {
  final Iterable<E> elements;
  final int size;
  final E padding;

  PartitionWithPaddingIterable(this.elements, this.size, this.padding);

  @override
  Iterator<Iterable<E>> get iterator => new PartitionWithPaddingIterator<E>(elements.iterator, size, padding);
}

class PartitionWithPaddingIterator<E> extends Iterator<Iterable<E>> {
  final Iterator<E> iterator;
  final int size;
  final E padding;

  bool completed = false;

  PartitionWithPaddingIterator(this.iterator, this.size, this.padding);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      current = null;
      return false;
    } else {
      current = <E>[];
      for (var i = 0; i < size; i++) {
        if (iterator.moveNext()) {
          current.add(iterator.current);
        } else {
          completed = true;
          if (current.isEmpty) {
            current = null;
            return false;
          }
          for (var j = i; j < size; j++) {
            current.add(padding);
          }
          return true;
        }
      }
    }
    return true;
  }
}
