import 'dart:collection';

import '../../../collection.dart';

class IntegerMap<T> extends MapBase<int, T> {
  IntegerMap(this.forward, this.backward);

  final int Function(int x) forward;
  final int Function(int x) backward;

  final storage = List<T?>.empty(growable: true);

  @override
  T? operator [](Object? key) {
    if (key is int) {
      final index = forward(key);
      if (0 <= index && index < storage.length) {
        return storage[index];
      }
    }
    return null;
  }

  @override
  void operator []=(int key, T value) {
    final index = forward(key);
    if (index >= storage.length) storage.length = 1 + index;
    storage[index] = value;
  }

  @override
  void clear() => storage.length = 0;

  @override
  Iterable<int> get keys => IntegerRange(storage.length)
      .where((i) => storage[i] != null)
      .map(backward);

  @override
  T? remove(Object? key) {
    if (key is int) {
      final index = forward(key);
      if (0 <= index && index < storage.length) {
        final value = storage[index];
        storage[index] = null;
        return value;
      }
    }
    return null;
  }
}
