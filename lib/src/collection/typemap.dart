import 'dart:collection' show MapBase, UnmodifiableMapView;

import 'package:meta/meta.dart';

/// A type map associates reified Dart [Type] arguments with instances of that
/// type.
///
/// Entries are keyed by the static generic type parameter `V` passed to
/// [hasInstance], [getInstance], [setInstance], and [removeInstance] (not by
/// `value.runtimeType`).
@optionalTypeArgs
class TypeMap<T> {
  final Map<Type, T> _map = <Type, T>{};

  /// Tests if the type map has an instance of the generic type [V].
  bool hasInstance<V extends T>() => _map.containsKey(V);

  /// Returns the instance corresponding to the generic type [V], or `null`.
  ///
  /// If the value is absent and an [ifAbsentPut] function is provided,
  /// populates the map with the result of said function.
  V? getInstance<V extends T>({V Function()? ifAbsentPut}) {
    final value = _map[V];
    if (value != null || _map.containsKey(V)) {
      return value as V;
    }
    if (ifAbsentPut == null) {
      return null;
    }
    return _map[V] = ifAbsentPut();
  }

  /// Sets the instance of the generic type [V] to [value].
  void setInstance<V extends T>(V value) => _map[V] = value;

  /// Removes and returns the instance of the generic type [V], or `null` if
  /// absent.
  V? removeInstance<V extends T>() => _map.remove(V) as V?;

  /// Removes all instances from this map.
  void clear() => _map.clear();

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

  /// Returns a live read-only view onto the underlying map.
  Map<Type, T> asMap() => UnmodifiableMapView<Type, T>(_map);

  @override
  String toString() => MapBase.mapToString(_map);
}
