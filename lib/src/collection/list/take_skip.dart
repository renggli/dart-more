import 'dart:math';

extension TakeSkipListExtension<E> on List<E> {
  /// Returns the list prefix up to the first occurrence of [element]. If the
  /// element is not found return the whole list.
  Iterable<E> takeTo(E element) {
    final index = indexOf(element);
    if (index < 0) return getRange(0, length);
    return getRange(0, index);
  }

  /// Returns the list suffix with [count] elements. If [count] is larger than
  /// [length] return the whole list.
  Iterable<E> takeLast(int count) => getRange(max(length - count, 0), length);

  /// Returns the list suffix after the last occurrence of [element]. If the
  /// element is not found return the whole list.
  Iterable<E> takeLastTo(E element) {
    final index = lastIndexOf(element);
    if (index < 0) return getRange(0, length);
    return getRange(index + 1, length);
  }

  /// Returns the list suffix after the first occurrence of [element]. If the
  /// element is not found return the empty list.
  Iterable<E> skipTo(E element) {
    final index = indexOf(element);
    if (index < 0) return getRange(0, 0);
    return getRange(index + 1, length);
  }

  /// Returns the list prefix without the last [count] elements. If [count]
  /// is larger than [length] return the empty list.
  Iterable<E> skipLast(int count) => getRange(0, max(length - count, 0));

  /// Returns the list prefix before the last occurrence of [element]. If the
  /// element is not found return the empty list.
  Iterable<E> skipLastTo(E element) {
    final index = lastIndexOf(element);
    if (index < 0) return getRange(0, 0);
    return getRange(0, index);
  }
}
