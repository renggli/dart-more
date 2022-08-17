extension MaxComparator<T> on Comparator<T> {
  /// Returns the maximum of the two arguments [a] and [b].
  T max(T a, T b) => this(a, b) > 0 ? a : b;

  /// Returns the maximum of the provided [iterable].
  T maxOf(Iterable<T> iterable, {T Function()? orElse}) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        value = max(value, iterator.current);
      }
      return value;
    }
    if (orElse == null) {
      throw StateError('Unable to find maximum in $iterable.');
    }
    return orElse();
  }
}
