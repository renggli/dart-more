import 'dart:collection';

/// An [Iterable] that uses a function to create [Iterator]s.
class PluggableIterable<E> extends IterableBase<E> {
  PluggableIterable(this.createIterator);

  final Iterator<E> Function() createIterator;

  @override
  Iterator<E> get iterator => createIterator();
}
