library more.iterable.mixins.unmodifiable;

/// Mixin for an unmodifiable [List] class.
///
/// Intended to mix-in on top of `ListBase<E>`.
abstract class UnmodifiableListMixin<E> implements List<E> {
  @override
  void operator []=(int index, E value) =>
      throw new UnsupportedError('Cannot modify an unmodifiable list.');

  @override
  set length(int newLength) =>
      throw new UnsupportedError('Cannot change the length of an unmodifiable list.');

  @override
  void setAll(int at, Iterable<E> iterable) =>
      throw new UnsupportedError('Cannot modify an unmodifiable list.');

  @override
  void add(E value) => throw new UnsupportedError('Cannot add to an unmodifiable list.');

  @override
  E insert(int index, E value) => throw new UnsupportedError('Cannot add to an unmodifiable list.');

  @override
  void insertAll(int at, Iterable<E> iterable) =>
      throw new UnsupportedError('Cannot add to an unmodifiable list.');

  @override
  void addAll(Iterable<E> iterable) =>
      throw new UnsupportedError('Cannot add to an unmodifiable list.');

  @override
  bool remove(Object element) =>
      throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  void removeWhere(bool test(E element)) =>
      throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  void retainWhere(bool test(E element)) =>
      throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  void sort([Comparator<E> compare]) =>
      throw new UnsupportedError('Cannot modify an unmodifiable list.');

  @override
  void clear() => throw new UnsupportedError('Cannot clear an unmodifiable list.');

  @override
  E removeAt(int index) => throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  E removeLast() => throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) =>
      throw new UnsupportedError('Cannot modify an unmodifiable list.');

  @override
  void removeRange(int start, int end) =>
      throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  void replaceRange(int start, int end, Iterable<E> iterable) =>
      throw new UnsupportedError('Cannot remove from an unmodifiable list.');

  @override
  void fillRange(int start, int end, [E fillValue]) =>
      throw new UnsupportedError('Cannot modify an unmodifiable list.');
}
