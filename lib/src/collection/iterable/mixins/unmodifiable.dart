import 'dart:math' show Random;

/// Mixin for an unmodifiable [List] class.
mixin UnmodifiableListMixin<E> on List<E> {
  @override
  void operator []=(int index, E value) => _throw();

  @override
  set first(E value) => _throw();

  @override
  set last(E value) => _throw();

  @override
  set length(int newLength) => _throw();

  @override
  void add(E value) => _throw();

  @override
  void addAll(Iterable<E> iterable) => _throw();

  @override
  void sort([Comparator<E>? compare]) => _throw();

  @override
  void shuffle([Random? random]) => _throw();

  @override
  void clear() => _throw();

  @override
  E insert(int index, E element) => _throw();

  @override
  void insertAll(int index, Iterable<E> iterable) => _throw();

  @override
  void setAll(int index, Iterable<E> iterable) => _throw();

  @override
  bool remove(Object? value) => _throw();

  @override
  E removeAt(int index) => _throw();

  @override
  E removeLast() => _throw();

  @override
  void removeWhere(bool Function(E element) test) => _throw();

  @override
  void retainWhere(bool Function(E element) test) => _throw();

  @override
  void setRange(
    int start,
    int end,
    Iterable<E> iterable, [
    int skipCount = 0,
  ]) => _throw();

  @override
  void removeRange(int start, int end) => _throw();

  @override
  void fillRange(int start, int end, [E? fillValue]) => _throw();

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) => _throw();
}

Never _throw() => throw UnsupportedError('Cannot modify an unmodifiable list');
