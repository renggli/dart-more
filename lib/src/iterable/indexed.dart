library more.iterable.indexed;

import 'dart:collection' show IterableBase;

/// Returns a [Indexed] iterable
///
/// By default the index is zero based, but an arbitrary [offset] can be
/// provided.
///
/// For example, the expression
///
///     indexed(['a', 'b'], offset: 1)
///       .map((each) => '${each.value}-${each.index}')
///       .join(', ');
///
/// returns
///
///     'a-1, b-2'
///
Iterable<Indexed<E>> indexed<E>(Iterable<E> iterable, {int offset: 0}) {
  return new IndexedIterable<E>(iterable, offset);
}

/// An indexed value.
class Indexed<E> {
  /// The index of the value in the iterable.
  final int index;

  /// The actual value.
  final E value;

  Indexed(this.index, this.value);

  @override
  String toString() => '$index: $value';
}

class IndexedIterable<E> extends IterableBase<Indexed<E>> {
  final Iterable<E> iterable;
  final int offset;

  IndexedIterable(this.iterable, this.offset);

  @override
  Iterator<Indexed<E>> get iterator =>
      new IndexedIterator<E>(iterable.iterator, offset);
}

class IndexedIterator<E> extends Iterator<Indexed<E>> {
  final Iterator<E> iterable;

  int index;

  IndexedIterator(this.iterable, this.index);

  @override
  Indexed<E> current;

  @override
  bool moveNext() {
    if (iterable.moveNext()) {
      current = new Indexed<E>(index++, iterable.current);
      return true;
    } else {
      current = null;
      return false;
    }
  }
}
