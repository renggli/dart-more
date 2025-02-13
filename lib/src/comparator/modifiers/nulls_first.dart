extension NullsFirstComparator<T> on Comparator<T> {
  /// Returns a [Comparator] that orders `null` values before non-null values.
  Comparator<T?> get nullsFirst => (a, b) {
    if (a == null && b == null) {
      return 0;
    } else if (a == null) {
      return -1;
    } else if (b == null) {
      return 1;
    }
    return this(a, b);
  };
}
