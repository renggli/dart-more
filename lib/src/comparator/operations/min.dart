extension MinComparator<T> on Comparator<T> {
  /// Returns the minimum of the two arguments [a] and [b].
  T min(T a, T b) => this(a, b) < 0 ? a : b;

  /// Returns the minimum of the provided [iterable].
  T minOf(Iterable<T> iterable, {T Function()? orElse}) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        value = min(value, iterator.current);
      }
      return value;
    }
    if (orElse == null) {
      throw StateError('Unable to find minimum in $iterable.');
    }
    return orElse();
  }
}
