import 'strategy/integer_map.dart';
import 'strategy/integer_set.dart';

/// Encapsulates data structures used for the various graph algorithms.
abstract class StorageStrategy<T> {
  /// Returns a suitable default strategy.
  factory defaultStrategy() = ObjectStorageStrategy;

  /// Returns a strategy using canonical collection objects.
  factory object() = ObjectStorageStrategy;

  /// Returns a strategy using canonical collection objects and object identity.
  factory identity() = IdentityStorageStrategy;

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

/// Strategy using canonical collection objects and identity comparison.
class IdentityStorageStrategy<T> implements StorageStrategy<T> {
  const new();

  @override
  Set<T> createSet() => Set<T>.identity();

  @override
  Map<T, R> createMap<R>() => Map<T, R>.identity();
}

/// Strategy using canonical collection objects.
class ObjectStorageStrategy<T> implements StorageStrategy<T> {
  @override
  Set<T> createSet() => <T>{};

  @override
  Map<T, R> createMap<R>() => <T, R>{};
}

/// Strategy for [int] objects.
class IntegerStorageStrategy implements StorageStrategy<int> {
  @override
  Set<int> createSet() => IntegerSet(_forward, _backward);

  @override
  Map<int, R> createMap<R>() => IntegerMap<R>(_forward, _backward);

  static int _forward(int x) => x < 0 ? -2 * x + 1 : 2 * x;

  static int _backward(int x) => x.isEven ? x ~/ 2 : (1 - x) ~/ 2;
}

/// Strategy for positive [int] objects.
class PositiveIntegerStorageStrategy implements StorageStrategy<int> {
  @override
  Set<int> createSet() => IntegerSet(_identity, _identity);

  @override
  Map<int, R> createMap<R>() => IntegerMap<R>(_identity, _identity);

  static int _identity(int x) {
    assert(x >= 0, 'Expected non-negative integer value, but got $x.');
    return x;
  }
}
