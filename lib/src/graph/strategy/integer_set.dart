import 'dart:collection';

import '../../../collection.dart';

class IntegerSet extends SetBase<int> {
  IntegerSet(this.forward, this.backward);

  final int Function(int x) forward;
  final int Function(int x) backward;

  final storage = BitList.empty(growable: true);

  @override
  bool add(int value) {
    final index = forward(value);
    if (index >= storage.length) {
      storage.length = 1 + index;
    } else if (storage.getUnchecked(index)) {
      return false;
    }
    storage.setUnchecked(index, true);
    return true;
  }

  @override
  bool contains(Object? element) {
    if (element is int) {
      final index = forward(element);
      return index < storage.length && storage.getUnchecked(index);
    }
    return false;
  }

  @override
  void clear() => storage.length = 0;

  @override
  Iterator<int> get iterator => storage.indices().map(backward).iterator;

  @override
  int get length => storage.count();

  @override
  int? lookup(Object? element) => throw UnimplementedError();

  @override
  bool remove(Object? value) {
    if (value is int) {
      final index = forward(value);
      if (index < storage.length && storage.getUnchecked(index)) {
        storage.setUnchecked(index, false);
        return true;
      }
    }
    return false;
  }

  @override
  Set<int> toSet() => IntegerSet(forward, backward)..addAll(this);
}
