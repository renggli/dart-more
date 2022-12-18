import '../../../functional.dart';

extension PredicateComparator<T> on Comparator<T> {
  /// Creates a predicate that evaluates to `true` for values equal to [a].
  Predicate1<T> equalTo(T a) => (T b) => this(a, b) == 0;

  /// Creates a predicate that evaluates to `true` for values equal to [a].
  Predicate1<T> notEqualTo(T a) => (T b) => this(a, b) != 0;

  /// Creates a predicate that evaluates to `true` for values smaller than [a].
  Predicate1<T> lessThan(T a) => (T b) => this(a, b) > 0;

  /// Creates a predicate that evaluates to `true` for values at most [a].
  Predicate1<T> lessThanOrEqualTo(T a) => (T b) => this(a, b) >= 0;

  /// Creates a predicate that evaluates to `true` for values more than [a].
  Predicate1<T> greaterThan(T a) => (T b) => this(a, b) < 0;

  /// Creates a predicate that evaluates to `true` for values at least [a].
  Predicate1<T> greaterThanOrEqualTo(T a) => (T b) => this(a, b) <= 0;
}
