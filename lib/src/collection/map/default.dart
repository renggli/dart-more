import 'dart:collection';

/// Extension on [Map] to provide a fallback default value.
extension DefaultMapExtension<K, V> on Map<K, V> {
  /// Returns a mutable view of this [Map] that responds with the provided
  /// default value, when the caller tries to access a non-existent key.
  ///
  /// As a consequence, the return type of the accessor `V operator [](Object?
  /// key)` is `V` and not `V?` like with a standard [Map].
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

/// A [MapView] that returns a default value for non-existent keys.
class MapWithDefault<K, V> extends MapView<K, V> {
  /// Creates a view of [map] that returns [defaultValue] for missing keys.
  new(super.map, this.defaultValue);

  /// The default value returned when an absent key is accessed.
  final V defaultValue;

  @override
  V operator [](Object? key) =>
      containsKey(key) ? super[key] as V : defaultValue;
}
