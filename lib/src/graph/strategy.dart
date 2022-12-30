import 'strategy/integer.dart';
import 'strategy/object.dart';
import 'strategy/positive_integer.dart';

/// Encapsulates data structures used for the various graph algorithms.
abstract class StorageStrategy<T> {
  /// Returns a suitable default strategy.
  factory StorageStrategy.defaultStrategy() =>
      T == int ? IntegerStrategy() as StorageStrategy<T> : ObjectStrategy<T>();

  /// Returns a strategy using canonical collection objects.
  factory StorageStrategy.objectStrategy() = ObjectStrategy;

  /// Returns a strategy for [int] objects.
  static StorageStrategy<int> integerStrategy() => IntegerStrategy();

  /// Returns a strategy for positive [int] objects.
  static StorageStrategy<int> positiveIntegerStrategy() =>
      PositiveIntegerStrategy();

  /// Creates an empty set of type `Set<T>`.
  Set<T> createSet();

  /// Creates an empty map of type `Map<T, R>`.
  Map<T, R> createMap<R>();
}
