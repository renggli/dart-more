part of more.iterable;

/// Returns an efficient empty iterable.
///
/// For example, the expression
///
///     empty()
///
/// results in the empty iterable:
///
///     []
///
Iterable/*<E>*/ empty/*<E>*/() => new _EmptyIterable/*<E>*/();

class _EmptyIterable<E> implements Iterable<E> {
  const _EmptyIterable();

  @override
  int get length => 0;

  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  @override
  Iterator<E> get iterator => const _EmptyIterator();

  @override
  bool any(bool test(element)) => false;

  @override
  bool every(bool test(element)) => true;

  @override
  bool contains(Object element) => false;

  @override
  void forEach(void f(element)) => null;

  @override
  Iterable/*<T>*/ map/*<T>*/(/*T*/ f(E e)) => this as Iterable<T>;

  @override
  Iterable<E> where(bool test(E element)) => this;

  @override
  Iterable/*<T>*/ expand/*<T>*/(Iterable/*<T>*/ f(E element)) => this as Iterable<T>;

  @override
  Iterable<E> skip(int count) => count < 0 ? throw new RangeError.value(count) : this;

  @override
  Iterable<E> skipWhile(bool test(E value)) => this;

  @override
  Iterable<E> take(int count) => count < 0 ? throw new RangeError.value(count) : this;

  @override
  Iterable<E> takeWhile(bool test(E value)) => this;

  @override
  E get first => throw new StateError('No elements');

  @override
  E get last => throw new StateError('No elements');

  @override
  E get single => throw new StateError('No elements');

  @override
  E firstWhere(bool test(E value), {E orElse()}) =>
      orElse == null ? throw new StateError('No matching element') : orElse();

  @override
  E lastWhere(bool test(E value), {E orElse()}) =>
      orElse == null ? throw new StateError('No matching element') : orElse();

  @override
  E singleWhere(bool test(value), {E orElse()}) =>
      orElse == null ? throw new StateError('No matching element') : orElse();

  @override
  dynamic/*=T*/ fold/*<T>*/(var/*=T*/ initialValue,
      dynamic/*=T*/ combine(var/*=T*/ previousValue, E element)) => initialValue;

  @override
  reduce(combine(value, element)) => throw new StateError('No elements');

  @override
  elementAt(int index) => throw new RangeError.value(index);

  @override
  List<E> toList({bool growable: true}) => new List<E>.from([], growable: growable);

  @override
  Set<E> toSet() => new Set<E>();

  @override
  String join([String separator = '']) => '';
}

class _EmptyIterator<E> implements Iterator<E> {
  const _EmptyIterator();

  @override
  E get current => null;

  @override
  bool moveNext() => false;
}
