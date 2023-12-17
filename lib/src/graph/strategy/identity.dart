import '../strategy.dart';

/// Strategy using canonical collection objects and identity comparison.
class IdentityStorageStrategy<T> implements StorageStrategy<T> {
  const IdentityStorageStrategy();

  @override
  Set<T> createSet() => Set<T>.identity();

  @override
  Map<T, R> createMap<R>() => Map<T, R>.identity();
}
