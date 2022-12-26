import 'strategy/default.dart';
import 'strategy/integer.dart';

/// Encapsulates data structures used for the various graph algorithms.
abstract class Strategy<T> {
  /// Returns a suitable default strategy.
  factory Strategy.defaultStrategy() =>
      T == int ? IntegerStrategy() as Strategy<T> : DefaultStrategy<T>();

  Set<T> createSet();

  Map<T, R> createMap<R>();
}
