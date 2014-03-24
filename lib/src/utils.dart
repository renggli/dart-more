library _utils;

/**
 * Mixin for infinitely sized iterables.
 *
 * Intended to mix-in on top of [IterableBase].
 */
abstract class InfiniteIterable<E> implements Iterable<E> {

  @override
  int get length {
    throw new StateError('Cannot return the length of an infinite iterable.');
  }

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => true;

  @override
  E get last {
    throw new StateError('Cannot return the last element of an infinite iterable.');
  }

  @override
  E lastWhere(bool test(E element), {E orElse()}) {
    throw new StateError('Cannot return the last element of an infinite iterable.');
  }

  @override
  E get single {
    throw new StateError('Cannot return the single element of an infinite iterable.');
  }

  @override
  E singleWhere(bool test(E element)) {
    throw new StateError('Cannot return the single element of an infinite iterable.');
  }

  @override
  List<E> toList({ bool growable: true }) {
    throw new StateError('Cannot convert an infinite iterable to a list.');
  }

  @override
  Set<E> toSet() {
    throw new StateError('Cannot convert an infinite iterable to a set.');
  }

}

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
