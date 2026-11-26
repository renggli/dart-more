/// Extension on [Comparable] objects providing range checking and clipping.
extension ComparableExtension<T> on Comparable<T> {
  /// Whether this object is between [min] and [max] (inclusive).
  bool between(T min, T max) => compareTo(min) >= 0 && compareTo(max) <= 0;

  /// Clips this object to the range from [min] to [max] (inclusive).
  ///
  /// The caller must ensure `min <= max` according to [compareTo] and that
  /// `this` is an instance of [T].
  T clip(T min, T max) => compareTo(min) < 0
      ? min
      : compareTo(max) > 0
      ? max
      : this as T;
}
