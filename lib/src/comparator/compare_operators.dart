/// A generic mixin that provides standard comparison operators like `<`, `<=`,
/// `>=`, and `>` provided the class implements [Comparable].
mixin CompareOperators<T> implements Comparable<T> {
  /// Whether this object is less than [other].
  bool operator <(T other) => compareTo(other) < 0;

  /// Whether this object is less than or equal to [other].
  bool operator <=(T other) => compareTo(other) <= 0;

  /// Whether this object is greater than or equal to [other].
  bool operator >=(T other) => compareTo(other) >= 0;

  /// Whether this object is greater than [other].
  bool operator >(T other) => compareTo(other) > 0;
}
