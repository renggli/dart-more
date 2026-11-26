import 'dart:collection';

import '../../collection/bitlist.dart';

/// A [Map] with integer keys.
///
/// The values are stored in a flat list for efficient access. The [_forward]
/// and [_backward] functions are used to map the keys to the list indices and
/// vice-versa.
class IntegerMap<T> extends MapBase<int, T> {
  new(this._forward, this._backward);

  final int Function(int x) _forward;
  final int Function(int x) _backward;

  final _presence = BitList.empty(growable: true);
  final _values = List<T?>.empty(growable: true);
  int _length = 0;

  @override
  int get length => _length;

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length > 0;

  @override
  bool containsKey(Object? key) {
    if (key is int) {
      final index = _forward(key);
      return 0 <= index && index < _presence.length && _presence[index];
    }
    return false;
  }

  @override
  T? operator [](Object? key) {
    if (key is int) {
      final index = _forward(key);
      if (0 <= index && index < _presence.length && _presence[index]) {
        return _values[index];
      }
    }
    return null;
  }

  @override
  void operator []=(int key, T value) {
    final index = _forward(key);
    if (index >= _presence.length) {
      _presence.length = _values.length = 1 + index;
    }
    if (!_presence[index]) {
      _presence[index] = true;
      _length++;
    }
    _values[index] = value;
  }

  @override
  void clear() {
    _presence.length = _values.length = 0;
    _length = 0;
  }

  @override
  Iterable<int> get keys => _presence.indices().map(_backward);

  @override
  T? remove(Object? key) {
    if (key is int) {
      final index = _forward(key);
      if (0 <= index && index < _presence.length && _presence[index]) {
        final value = _values[index];
        _presence[index] = false;
        _values[index] = null;
        _length--;
        return value;
      }
    }
    return null;
  }
}
