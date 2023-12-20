extension MinMaxComparator<T> on Comparator<T> {
  /// Returns the minimum of the two arguments [a] and [b].
  T min(T a, T b) => this(a, b) < 0 ? a : b;

  /// Returns the maximum of the provided [iterable].
  T minOf(Iterable<T> iterable, {T Function()? orElse}) =>
      orElse != null && iterable.isEmpty ? orElse() : iterable.reduce(min);

  /// Returns the maximum of the two arguments [a] and [b].
  T max(T a, T b) => this(a, b) > 0 ? a : b;

  /// Returns the maximum of the provided [iterable].
  T maxOf(Iterable<T> iterable, {T Function()? orElse}) =>
      orElse != null && iterable.isEmpty ? orElse() : iterable.reduce(max);

  /// Returns a tuple with the minimum and maximum of the provided [iterable].
  ({T min, T max}) minMaxOf(Iterable<T> iterable,
      {({T min, T max}) Function()? orElse}) {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      var minValue = iterator.current;
      var maxValue = iterator.current;
      while (iterator.moveNext()) {
        minValue = min(minValue, iterator.current);
        maxValue = max(maxValue, iterator.current);
      }
      return (min: minValue, max: maxValue);
    }
    if (orElse == null) throw StateError("No element");
    return orElse();
  }
}
