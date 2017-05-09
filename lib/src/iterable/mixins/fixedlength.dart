part of more.iterable;

/// Mixin that throws on the length changing operations of [List].
///
/// Intended to mix-in on top of [ListMixin] for fixed-length lists.
abstract class FixedLengthListMixin<E> implements List<E> {

  @override
  set length(int newLength) {
    throw new UnsupportedError('Cannot change the length of a fixed-length list.');
  }

  @override
  void add(E value) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  @override
  void insert(int index, E value) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  @override
  void insertAll(int at, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  @override
  void addAll(Iterable<E> iterable) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  @override
  bool remove(Object element) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  @override
  void removeWhere(bool test(E element)) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  @override
  void retainWhere(bool test(E element)) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  @override
  void clear() {
    throw new UnsupportedError('Cannot clear a fixed-length list.');
  }

  @override
  E removeAt(int index) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  @override
  E removeLast() {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  @override
  void removeRange(int start, int end) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  @override
  void replaceRange(int start, int end, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }
}
