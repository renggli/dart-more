library more.iterable.partition;

import 'dart:collection' show IterableBase;

/// Marker for an absent padding object.
const dynamic noPadding = const Object();

/// Divides an `iterable` into sub-iterables of a given `size`. If no `padding` is provided, the
/// final iterable is smaller or equal the desired side, otherwise the final iterable will be
/// padded with the provided object.
///
/// The following expression yields [1, 2], [3, 4], [5, null]:
///
///     partition([1, 2, 3, 4, 5], 2, null);
Iterable<Iterable<E>> partition<E>(Iterable<E> elements, int size, [E padding = noPadding]) {
  return new PartitionIterable<E>(elements, size, padding);
}

class PartitionIterable<E> extends IterableBase<Iterable<E>> {
  final Iterable<E> elements;
  final int size;
  final E padding;

  PartitionIterable(this.elements, this.size, this.padding);

  @override
  Iterator<Iterable<E>> get iterator => new PartitionIterator<E>(elements.iterator, size, padding);
}

class PartitionIterator<E> extends Iterator<Iterable<E>> {
  final Iterator<E> iterator;
  final int size;
  final E padding;

  bool completed = false;

  PartitionIterator(this.iterator, this.size, this.padding);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      current = null;
      return false;
    } else {
      current = new List<E>();
      for (var i = 0; i < size; i++) {
        if (iterator.moveNext()) {
          current.add(iterator.current);
        } else {
          completed = true;
          if (current.isEmpty) {
            current = null;
            return false;
          }
          if (noPadding != padding) {
            for (var j = i; j < size; j++) {
              current.add(padding);
            }
          }
          return true;
        }
      }
    }
    return true;
  }
}
