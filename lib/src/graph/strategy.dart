import 'strategy/default.dart';
import 'strategy/integer.dart';

/// Encapsulates data structures used for the various graph algorithms.
abstract class GraphStrategy<T> {
  /// Returns a suitable default strategy.
  factory GraphStrategy.defaultStrategy() => T == int
      ? IntegerGraphStrategy() as GraphStrategy<T>
      : DefaultGraphStrategy<T>();

  Set<T> createSet();

  Map<T, R> createMap<R>();
}
