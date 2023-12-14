import '../strategy.dart';
import 'integer_map.dart';
import 'integer_set.dart';

/// Strategy for [int] objects.
class PositiveIntegerStorageStrategy implements StorageStrategy<int> {
  @override
  Set<int> createSet() => IntegerSet(identity, identity);

  @override
  Map<int, R> createMap<R>() => IntegerMap<R>(identity, identity);
}

int identity(int x) {
  assert(x >= 0, 'Expected non-negative integer value, but got $x.');
  return x;
}
