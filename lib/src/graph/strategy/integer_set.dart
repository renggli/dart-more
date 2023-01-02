import 'dart:collection';

import '../../../collection.dart';

/// A [Set] with integer values.
///
/// The presence of values is stored in an efficient [BitList]. The [_forward]
/// and [_backward] functions are used to map the values to the list indices
/// and vice-versa.
class IntegerSet extends SetBase<int> {
  IntegerSet(this._forward, this._backward);

  final int Function(int x) _forward;
  final int Function(int x) _backward;

  final _presence = BitList.empty(growable: true);

  @override
  bool add(int value) {
    final index = _forward(value);
    if (index >= _presence.length) {
      _presence.length = 1 + index;
    } else if (_presence.getUnchecked(index)) {
      return false;
    }
    _presence.setUnchecked(index, true);
    return true;
  }

  @override
  bool contains(Object? element) {
    if (element is int) {
      final index = _forward(element);
      return index < _presence.length && _presence.getUnchecked(index);
    }
    return false;
  }

  @override
  void clear() => _presence.length = 0;

  @override
  Iterator<int> get iterator => _presence.indices().map(_backward).iterator;

  @override
  int get length => _presence.count();

  @override
  int? lookup(Object? element) => throw UnimplementedError();

  @override
  bool remove(Object? value) {
    if (value is int) {
      final index = _forward(value);
      if (index < _presence.length && _presence.getUnchecked(index)) {
        _presence.setUnchecked(index, false);
        return true;
      }
    }
    return false;
  }

  @override
  Set<int> toSet() => IntegerSet(_forward, _backward)..addAll(this);
}
