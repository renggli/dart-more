part of more.iterable;

/// Divides an `iterable` into sub-iterables of a given `size`. If no `padding` is provided, the
/// final iterable is smaller or equal the desired side, otherwise the final iterable will be
/// padded with the provided object.
///
/// The following expression yields [1, 2], [3, 4], [5, null]:
///
///     partition([1, 2, 3, 4, 5], 2, null);
Iterable<Iterable<E>> partition<E>(Iterable<E> elements, int size, [padding = _sentinel]) {
  return new _PartitionIterable<E>(elements, size, padding);
}

const _sentinel = const Object();

class _PartitionIterable<E> extends IterableBase<Iterable<E>> {

  final Iterable<E> elements;
  final int size;
  final Object padding;

  _PartitionIterable(this.elements, this.size, this.padding);

  @override
  Iterator<Iterable<E>> get iterator => new _PartitionIterator<E>(elements.iterator, size, padding);

}

class _PartitionIterator<E> extends Iterator<Iterable<E>> {

  final Iterator<E> iterator;
  final int size;
  final Object padding;

  bool completed = false;

  _PartitionIterator(this.iterator, this.size, this.padding);

  @override
  List<E> current;

  @override
  bool moveNext() {
    if (completed) {
      current = null;
      return false;
    } else {
      current = new List();
      for (var i = 0; i < size; i++) {
        if (iterator.moveNext()) {
          current.add(iterator.current);
        } else {
          completed = true;
          if (current.isEmpty) {
            current = null;
            return false;
          }
          if (_sentinel != padding) {
            for (var j = i; j < size; j++) {
              current.add(padding as E);
            }
          }
          return true;
        }
      }
    }
    return true;
  }
}
