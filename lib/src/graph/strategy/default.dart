import '../strategy.dart';

class DefaultGraphStrategy<T> implements GraphStrategy<T> {
  @override
  Set<T> createSet() => <T>{};

  @override
  Map<T, R> createMap<R>() => <T, R>{};
}
