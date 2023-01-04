import 'strategy/integer.dart';
import 'strategy/object.dart';
import 'strategy/positive_integer.dart';

/// Encapsulates data structures used for the various graph algorithms.
abstract class StorageStrategy<T> {
  /// Returns a suitable default strategy.
  factory StorageStrategy.defaultStrategy() = ObjectStorageStrategy;

  /// Returns a strategy using canonical collection objects.
  factory StorageStrategy.object() = ObjectStorageStrategy;

  /// Returns a strategy for [int] objects.
  static StorageStrategy<int> integer() => IntegerStorageStrategy();

  /// Returns a strategy for positive [int] objects.
  static StorageStrategy<int> positiveInteger() =>
      PositiveIntegerStorageStrategy();

  /// Creates an empty set of type `Set<T>`.
  Set<T> createSet();

  /// Creates an empty map of type `Map<T, R>`.
  Map<T, R> createMap<R>();
}
