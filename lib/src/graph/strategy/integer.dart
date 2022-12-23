import 'dart:collection';

import '../../../collection.dart';
import '../strategy.dart';

class IntegerGraphStrategy implements GraphStrategy<int> {
  @override
  Set<int> createSet() => IntegerSet();

  @override
  Map<int, T> createMap<T>() => IntegerMap<T>();
}

class IntegerSet extends SetBase<int> {
  final storage = BitList.empty(growable: true);

  @override
  bool add(int value) {
    RangeError.checkNotNegative(value, 'value');
    if (value >= storage.length) {
      storage.length = 1 + value;
    } else if (storage.getUnchecked(value)) {
      return false;
    }
    storage.setUnchecked(value, true);
    return true;
  }

  @override
  bool contains(Object? element) =>
      element is int &&
      element < storage.length &&
      storage.getUnchecked(element);

  @override
  Iterator<int> get iterator => storage.indices().iterator;

  @override
  int get length => storage.count();

  @override
  int? lookup(Object? element) => throw UnimplementedError();

  @override
  bool remove(Object? value) {
    if (value is int && value < storage.length && storage.getUnchecked(value)) {
      storage.setUnchecked(value, false);
      return true;
    }
    return false;
  }

  @override
  Set<int> toSet() => throw UnimplementedError();
}

class IntegerMap<T> extends MapBase<int, T> {
  final storage = List<T?>.empty(growable: true);

  @override
  T? operator [](Object? key) =>
      key is int && 0 <= key && key < storage.length ? storage[key] : null;

  @override
  void operator []=(int key, T value) {
    RangeError.checkNotNegative(key, 'key');
    if (key >= storage.length) storage.length = 1 + key;
    storage[key] = value;
  }

  @override
  void clear() => storage.clear();

  @override
  Iterable<int> get keys =>
      IntegerRange(storage.length).where((i) => storage[i] != null);

  @override
  T? remove(Object? key) {
    if (key is int && 0 <= key && key < storage.length) {
      final value = storage[key];
      storage[key] = null;
      return value;
    }
    return null;
  }
}
