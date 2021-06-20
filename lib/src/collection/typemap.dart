import 'dart:collection';

import 'package:meta/meta.dart';

/// A type-map associates dart runtime types to an instance of that type.
@optionalTypeArgs
class TypeMap<T> {
  final Map<Type, T> _map = Map.identity();

  /// Tests if the type map has an instance of the generic type [V].
  bool hasInstance<V extends T>() => _map.containsKey(V);

  /// Returns the instance corresponding to the generic type [V], or `null`.
  ///
  /// If the value is absent and an [ifAbsentPut] function is provided,
  /// populates the map with the result of said function.
  V? getInstance<V extends T>({V Function()? ifAbsentPut}) {
    final value = _map[V];
    if (value == null) {
      if (ifAbsentPut == null) {
        return null;
      } else {
        return _map[V] = ifAbsentPut();
      }
    } else {
      return value as V;
    }
  }

  /// Sets the instance of the generic type [V] to [value].
  void setInstance<V extends T>(V value) => _map[V] = value;

  /// Returns the types of this map.
  Iterable<Type> get types => _map.keys;

  /// Returns the instances of this map.
  Iterable<T> get instances => _map.values;

  /// Returns the number of elements in this map.
  int get length => _map.length;

  /// Whether there is nothing in this map.
  bool get isEmpty => _map.isEmpty;

  /// Whether there is at least one instance in the map.
  bool get isNotEmpty => _map.isNotEmpty;

  /// Returns a readonly view onto the underlying map.
  Map<Type, T> asMap() => Map.unmodifiable(_map);

  @override
  String toString() => MapBase.mapToString(_map);
}
