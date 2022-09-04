/// A generic mixin that provides standard comparison operators like
/// `<`, `<=`, `>=` and `>` provided the class is `Comparable`.
mixin CompareOperators<T> implements Comparable<T> {
  bool operator <(T other) => compareTo(other) < 0;
  bool operator <=(T other) => compareTo(other) <= 0;
  bool operator >=(T other) => compareTo(other) >= 0;
  bool operator >(T other) => compareTo(other) > 0;
}
