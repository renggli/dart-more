extension ComparableExtension<T> on Comparable<T> {
  /// Returns true, if this [Comparable] is between [min] and [max] (inclusive).
  bool between(T min, T max) => compareTo(min) >= 0 && compareTo(max) <= 0;

  /// Clips (limits) this [Comparable] to the range from [min] to [max].
  T clip(T min, T max) => compareTo(min) < 0
      ? min
      : compareTo(max) > 0
      ? max
      : this as T;
}
