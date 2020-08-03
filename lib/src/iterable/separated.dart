library more.iterable.separated;

import 'dart:collection';

/// Function type to build separator elements.
typedef Builder<E> = E Function();

extension SeparatedExtension<E> on Iterable<E> {
  /// Returns an [Iterable] where every element is separated by an element
  /// built by the provided [builder].
  ///
  /// Example:
  ///
  ///    [1, 2, 3].separatedBy(() => 0);     // [1, 0, 2, 0, 3]
  ///
  Iterable<E> separatedBy(Builder<E> builder) =>
      SeparatedIterable<E>(this, builder);
}

class SeparatedIterable<E> extends IterableBase<E> {
  final Iterable<E> iterable;
  final Builder<E> builder;

  SeparatedIterable(this.iterable, this.builder);

  @override
  Iterator<E> get iterator => SeparatedIterator<E>(iterable.iterator, builder);
}

class SeparatedIterator<E> extends Iterator<E> {
  final Iterator<E> iterator;
  final Builder<E> builder;

  @override
  E current;

  bool hasCompleted = false;
  bool isSeparator = false;
  bool isFirst = true;

  SeparatedIterator(this.iterator, this.builder);

  @override
  bool moveNext() {
    if (hasCompleted) {
      return false;
    } else if (isFirst) {
      isFirst = false;
      if (iterator.moveNext()) {
        current = iterator.current;
        return true;
      } else {
        hasCompleted = true;
        return false;
      }
    } else if (isSeparator) {
      isSeparator = false;
      current = iterator.current;
      return true;
    } else if (iterator.moveNext()) {
      isSeparator = true;
      current = builder();
      return true;
    } else {
      hasCompleted = true;
      current = null;
      return false;
    }
  }
}
