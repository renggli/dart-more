import 'dart:collection';

extension ComputedMapExtension<K, V> on Map<K, V> {
  /// Returns a mutable view of this map that computes and stores absent
  /// keys with the provided [computation].
  ///
  /// As a consequence, the return type of the accessor `V operator [](Object?
  /// key)` is `V` and not `V?` like with a standard [Map].
  ///
  /// For example:
  ///
  /// ```dart
  /// final map = <String, int>{}.withComputed((key) => int.parse(key));
  /// print(map.containsKey('42'));  // false
  /// print(map['42']);              // 42
  /// print(map.containsKey('42'));  // true
  /// ```
  MapWithComputed<K, V> withComputed(V Function(K key) computation) =>
      MapWithComputed(this, computation);
}

class MapWithComputed<K, V> extends MapView<K, V> {
  MapWithComputed(super.map, this.computation);

  final V Function(K key) computation;

  @override
  V operator [](Object? key) {
    if (containsKey(key)) return super[key] as V;
    if (key is K) return super[key] = computation(key);
    return throw TypeError();
  }
}
