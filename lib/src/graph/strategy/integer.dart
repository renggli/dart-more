import '../strategy.dart';
import 'integer_map.dart';
import 'integer_set.dart';

/// Strategy for [int] objects.
class IntegerStrategy implements StorageStrategy<int> {
  @override
  Set<int> createSet() => IntegerSet(forward, backward);

  @override
  Map<int, T> createMap<T>() => IntegerMap<T>(forward, backward);
}

int forward(int x) => x < 0 ? -2 * x + 1 : 2 * x;

int backward(int x) => x.isEven ? x ~/ 2 : (1 - x) ~/ 2;
