import 'package:checks/checks.dart';
import 'package:more/interval.dart';

/// Extension on [Subject] of [Interval] providing domain-specific checks.
extension IntervalChecks<T extends Comparable<T>> on Subject<Interval<T>> {
  /// Extracts the lower bound of the interval for further assertions.
  Subject<T> get lower => has((i) => i.lower, 'lower');

  /// Extracts the upper bound of the interval for further assertions.
  Subject<T> get upper => has((i) => i.upper, 'upper');

  /// Asserts that the interval represents a single point.
  void isSingle() => has((i) => i.isSingle, 'isSingle').isTrue();

  /// Asserts that the interval does not represent a single point.
  void isNotSingle() => has((i) => i.isSingle, 'isSingle').isFalse();
}
