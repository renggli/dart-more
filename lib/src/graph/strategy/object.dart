import '../strategy.dart';

/// Strategy using canonical collection objects.
class ObjectStorageStrategy<T> implements StorageStrategy<T> {
  @override
  Set<T> createSet() => <T>{};

  @override
  Map<T, R> createMap<R>() => <T, R>{};
}
