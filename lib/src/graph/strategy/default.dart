import '../strategy.dart';

class DefaultStrategy<T> implements StorageStrategy<T> {
  @override
  Set<T> createSet() => <T>{};

  @override
  Map<T, R> createMap<R>() => <T, R>{};
}
