import 'dart:collection' show IterableBase;

import 'mixins/infinite.dart';

/// Returns an infinite iterable with a constant [element]. If [count] is
/// provided the resulting iterator is limited to [count] elements.
///
/// For example:
///
/// ```dart
/// repeat(2);               // [2, 2, 2, 2, 2, 2, ...]
/// repeat('a', count: 3);   // ['a', 'a', 'a']
/// ```
Iterable<E> repeat<E>(E element, {int? count}) {
  if (count == 0) {
    return const [];
  } else if (count == null) {
    return RepeatElementIterable<E>(element);
  } else {
    RangeError.checkNotNegative(count, 'count');
    return RepeatCountElementIterable<E>(element, count);
  }
}

class RepeatElementIterable<E> extends IterableBase<E>
    with InfiniteIterable<E> {
  new(this.element);

  final E element;

  @override
  bool contains(Object? element) => this.element == element;

  @override
  Iterator<E> get iterator => RepeatElementIterator<E>(element);
}

class RepeatCountElementIterable<E> extends IterableBase<E> {
  new(this.element, this.length);

  final E element;

  @override
  final int length;

  @override
  bool get isEmpty => false;

  @override
  bool contains(Object? element) => this.element == element;

  @override
  E elementAt(int index) {
    RangeError.checkValidIndex(index, this, 'index', length);
    return element;
  }

  @override
  Iterator<E> get iterator => RepeatCountElementIterator<E>(element, length);
}

class RepeatElementIterator<E> implements Iterator<E> {
  new(this.current);

  @override
  final E current;

  @override
  bool moveNext() => true;
}

class RepeatCountElementIterator<E> implements Iterator<E> {
  new(this.current, this._remaining);

  @override
  final E current;
  int _remaining;

  @override
  bool moveNext() {
    if (_remaining > 0) {
      _remaining--;
      return true;
    }
    return false;
  }
}
