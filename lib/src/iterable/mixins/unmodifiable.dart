part of iterable;

/**
 * Mixin for an unmodifiable [List] class.
 *
 * This overrides all mutating methods with methods that throw.
 * This mixin is intended to be mixed in on top of [ListMixin] on
 * unmodifiable lists.
 */
abstract class UnmodifiableListMixin<E> implements List<E> {

  void operator []=(int index, E value) {
    throw new UnsupportedError('Cannot modify an unmodifiable list.');
  }

  void set length(int newLength) {
    throw new UnsupportedError('Cannot change the length of an unmodifiable list.');
  }

  void setAll(int at, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot modify an unmodifiable list.');
  }

  void add(E value) {
    throw new UnsupportedError('Cannot add to an unmodifiable list.');
  }

  E insert(int index, E value) {
    throw new UnsupportedError('Cannot add to an unmodifiable list.');
  }

  void insertAll(int at, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot add to an unmodifiable list.');
  }

  void addAll(Iterable<E> iterable) {
    throw new UnsupportedError('Cannot add to an unmodifiable list.');
  }

  bool remove(Object element) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void removeAll(Iterable elements) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void retainAll(Iterable elements) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void removeWhere(bool test(E element)) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void retainWhere(bool test(E element)) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void sort([Comparator<E> compare]) {
    throw new UnsupportedError('Cannot modify an unmodifiable list.');
  }

  void clear() {
    throw new UnsupportedError('Cannot clear an unmodifiable list.');
  }

  E removeAt(int index) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  E removeLast() {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    throw new UnsupportedError('Cannot modify an unmodifiable list.');
  }

  void removeRange(int start, int end) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void replaceRange(int start, int end, Iterable<E> iterable) {
    throw new UnsupportedError('Cannot remove from an unmodifiable list.');
  }

  void fillRange(int start, int end, [E fillValue]) {
    throw new UnsupportedError('Cannot modify an unmodifiable list.');
  }

}
