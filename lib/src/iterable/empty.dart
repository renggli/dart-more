part of iterable;

/**
 * Returns an iterable whose iterator is empty.
 */
Iterable empty() => const _EmptyIterable();

class _EmptyIterable extends IterableBase {

  @override
  int get length => 0;

  @override
  bool get isEmpty => true;

  @override
  Iterator get iterator => const _EmptyIterator();

}

class _EmptyIterator extends Iterator {

  @override
  Object get current => null;

  @override
  bool moveNext() => false;

}