import 'strategy/default.dart';
import 'strategy/integer.dart';

/// Encapsulates data structures used for the various graph algorithms.
abstract class StorageStrategy<T> {
  /// Returns a suitable default strategy.
  factory StorageStrategy.defaultStrategy() =>
      T == int ? IntegerStrategy() as StorageStrategy<T> : DefaultStrategy<T>();

  Set<T> createSet();

  Map<T, R> createMap<R>();
}
