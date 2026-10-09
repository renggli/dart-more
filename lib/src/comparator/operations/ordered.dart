/// Extension on [Comparator] to check ordering of iterables.
extension OrderedComparator<T> on Comparator<T> {
  /// Whether the specified [iterable] is in increasing order.
  bool isOrdered(Iterable<T> iterable) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var previous = iterator.current;
      while (iterator.moveNext()) {
        if (this(previous, iterator.current) > 0) {
          return false;
        }
        previous = iterator.current;
      }
    }
    return true;
  }

  /// Whether the specified [iterable] is in strict increasing order.
  bool isStrictlyOrdered(Iterable<T> iterable) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var previous = iterator.current;
      while (iterator.moveNext()) {
        if (this(previous, iterator.current) >= 0) {
          return false;
        }
        previous = iterator.current;
      }
    }
    return true;
  }
}
