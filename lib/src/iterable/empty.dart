part of iterable;

/**
 * Returns an efficient empty iterable.
 *
 * For example, the expression
 *
 *     empty()
 *
 * results in the empty iterable:
 *
 *     []
 *
 */
Iterable/*<E>*/ empty() => const _EmptyIterable();

class _EmptyIterable<E> implements Iterable<E> {

  const _EmptyIterable();

  @override
  int get length => 0;

  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  @override
  Iterator get iterator => const _EmptyIterator();

  @override
  bool any(bool test(element)) => false;

  @override
  bool every(bool test(element)) => true;

  @override
  bool contains(Object element) => false;

  @override
  void forEach(void f(element)) => null;

  @override
  Iterable map(f(element)) => this;

  @override
  Iterable where(bool test(element)) => this;

  @override
  Iterable expand(Iterable f(element)) => this;

  @override
  Iterable skip(int count) => count < 0
      ? throw new RangeError.value(count)
      : this;

  @override
  Iterable skipWhile(bool test(value)) => this;

  @override
  Iterable take(int count) => count < 0
      ? throw new RangeError.value(count)
      : this;

  @override
  Iterable takeWhile(bool test(value)) => this;

  @override
  get first => throw new StateError('No elements');

  @override
  get last => throw new StateError('No elements');

  @override
  get single => throw new StateError('No elements');

  @override
  firstWhere(bool test(value), { orElse() }) => orElse == null
      ? throw new StateError('No matching element')
      : orElse();

  @override
  lastWhere(bool test(value), { orElse() }) => orElse == null
      ? throw new StateError('No matching element')
      : orElse();

  @override
  singleWhere(bool test(value), { orElse() }) => orElse == null
      ? throw new StateError('No matching element')
      : orElse();

  @override
  fold(initialValue, combine(previousValue, element)) => initialValue;

  @override
  reduce(combine(value, element)) => throw new StateError('No elements');

  @override
  elementAt(int index) => throw new RangeError.value(index);

  @override
  List toList({bool growable: true}) => new List.from([], growable: growable);

  @override
  Set toSet() => new Set();

  @override
  String join([String separator]) => '';

}

class _EmptyIterator implements Iterator {

  const _EmptyIterator();

  @override
  Object get current => null;

  @override
  bool moveNext() => false;

}