extension PredicateComparator<T> on Comparator<T> {
  /// A predicate that evaluates to `true` if [a] equals [b].
  bool equalTo(T a, T b) => this(a, b) == 0;

  /// A predicate that evaluates to `true` if [a] not equals to [b].
  bool notEqualTo(T a, T b) => this(a, b) != 0;

  /// A predicate that evaluates to `true` if [a] is smaller than [b].
  bool lessThan(T a, T b) => this(a, b) < 0;

  /// A predicate that evaluates to `true` if [a] is smaller or equal to [b].
  bool lessThanOrEqualTo(T a, T b) => this(a, b) <= 0;

  /// A predicate that evaluates to `true` if [a] is larger than [b].
  bool greaterThan(T a, T b) => this(a, b) > 0;

  /// A predicate that evaluates to `true` if [a] is larger or equal to [b].
  bool greaterThanOrEqualTo(T a, T b) => this(a, b) >= 0;
}
