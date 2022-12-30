import '../strategy.dart';
import 'integer_map.dart';
import 'integer_set.dart';

/// Strategy for [int] objects.
class PositiveIntegerStrategy implements StorageStrategy<int> {
  @override
  Set<int> createSet() => IntegerSet(positiveInteger, positiveInteger);

  @override
  Map<int, T> createMap<T>() => IntegerMap<T>(positiveInteger, positiveInteger);
}

int positiveInteger(int x) {
  assert(x >= 0, '$x is expected to be positive');
  return x;
}
