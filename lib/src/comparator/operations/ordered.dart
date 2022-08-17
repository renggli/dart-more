extension OrderedComparator<T> on Comparator<T> {
  /// Tests if the specified [iterable] is in increasing order.
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

  /// Tests if the specified [Iterable] is in strict increasing order.
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
