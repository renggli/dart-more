part of iterable;

/**
 * Mixin that throws on the length changing operations of [List].
 *
 * Intended to mix-in on top of [ListMixin] for fixed-length lists.
 */
abstract class FixedLengthListMixin<E> implements List<E> {

  void set length(int newLength) {
    throw new UnsupportedError('Cannot change the length of a fixed-length list.');
  }

  void add(E value) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  void insert(int index, E value) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  void insertAll(int at, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  void addAll(Iterable<E> iterable) {
    throw new UnsupportedError('Cannot add to a fixed-length list.');
  }

  bool remove(Object element) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void removeAll(Iterable elements) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void retainAll(Iterable elements) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void removeWhere(bool test(E element)) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void retainWhere(bool test(E element)) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void clear() {
    throw new UnsupportedError('Cannot clear a fixed-length list.');
  }

  E removeAt(int index) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  E removeLast() {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void removeRange(int start, int end) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

  void replaceRange(int start, int end, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot remove from a fixed-length list.');
  }

}