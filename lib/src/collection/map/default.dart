import 'dart:collection';

extension DefaultMapExtension<K, V> on Map<K, V> {
  /// Returns a mutable view of this map that responds with the provided
  /// default value, when the caller tries to access a non-existent key.
  ///
  /// For example:
  ///
  /// ```dart
  /// final map = {'a': 1}.withDefault(42);
  /// print(map['z']);  // 42
  /// print(map.containsKey('z'));  // false
  /// ```
  MapWithDefault<K, V> withDefault(V value) => MapWithDefault(this, value);
}

class MapWithDefault<K, V> extends MapView<K, V> {
  MapWithDefault(super.map, this.defaultValue);

  final V defaultValue;

  @override
  V operator [](Object? key) =>
      containsKey(key) ? super[key] as V : defaultValue;
}
