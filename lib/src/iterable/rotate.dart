import 'dart:collection';

extension RotateListExtension<E> on List<E> {
  /// In-place rotate the list [steps] steps to the right. If [steps] is
  /// negative, the list is rotated to the left.
  ///
  /// Rotating one step to the right (steps = 1) is equivalent to
  /// `list.insert(0, list.removeLast())`. Rotating one step to the left
  /// (step = -1) is equivalent to `list.add(list.removeAt(0))`.
  void rotate(int steps) {
    final length = this.length;
    if (length > 1) {
      final count = steps % length;
      if (count != 0) {
        final other = length - count;
        if (count <= other) {
          final copy = sublist(other);
          setRange(count, length, this);
          setRange(0, copy.length, copy);
        } else {
          final copy = sublist(0, other);
          setRange(0, count, this, other);
          setRange(count, length, copy);
        }
      }
    }
  }
}

extension RotateQueueExtension<E> on Queue<E> {
  /// In-place rotate the queue [steps] steps to the right. If [steps] is
  /// negative, the list is rotated to the left.
  ///
  /// Rotating one step to the right (steps = 1) is equivalent to
  /// `queue.addFirst(list.removeLast())`. Rotating one step to the left
  /// (step = -1) is equivalent to `list.addLast(list.removeFirst())`.
  void rotate(int steps) {
    final length = this.length;
    if (length > 1) {
      var count = steps % length;
      if (count != 0) {
        var other = length - count;
        if (count <= other) {
          while (count-- > 0) {
            addFirst(removeLast());
          }
        } else {
          while (other-- > 0) {
            addLast(removeFirst());
          }
        }
      }
    }
  }
}
