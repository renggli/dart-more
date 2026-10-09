/// Extension on [Comparator] providing relational comparison predicates.
extension PredicateComparator<T> on Comparator<T> {
  /// Whether [a] equals [b].
  bool equalTo(T a, T b) => this(a, b) == 0;

  /// Whether [a] is not equal to [b].
  bool notEqualTo(T a, T b) => this(a, b) != 0;

  /// Whether [a] is less than [b].
  bool lessThan(T a, T b) => this(a, b) < 0;

  /// Whether [a] is less than or equal to [b].
  bool lessThanOrEqualTo(T a, T b) => this(a, b) <= 0;

  /// Whether [a] is greater than [b].
  bool greaterThan(T a, T b) => this(a, b) > 0;

  /// Whether [a] is greater than or equal to [b].
  bool greaterThanOrEqualTo(T a, T b) => this(a, b) >= 0;
}
