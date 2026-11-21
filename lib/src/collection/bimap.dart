import 'dart:collection';

/// A bi-map associates keys with values and values with keys.
///
/// Bi-maps behave like maps from key to values, but can efficiently provide an
/// inverse bi-map that maps values to keys. Also certain operations, such as
/// [containsValue] are much more efficient than with traditional maps.
class BiMap<K, V> extends MapBase<K, V> {
  /// Creates an empty bi-map.
  factory() => BiMap<K, V>._({}, {}, isIdentity: false);

  /// Creates an empty identity bi-map.
  factory identity() =>
      BiMap<K, V>._(Map.identity(), Map.identity(), isIdentity: true);

  /// Creates a bi-map from another map.
  factory of(Map<K, V> other) {
    if (other is BiMap<K, V> && !other._isIdentity) {
      return BiMap<K, V>._(
        Map<K, V>.of(other._forward),
        Map<V, K>.of(other._backward),
        isIdentity: false,
      );
    } else {
      return BiMap<K, V>()..addAll(other);
    }
  }

  /// Creates a bi-map from another map, casting keys to [K] and values to [V].
  factory from(Map<Object?, Object?> other) {
    final result = BiMap<K, V>();
    other.forEach((key, value) {
      result[key as K] = value as V;
    });
    return result;
  }

  /// Creates a bi-map from an iterable (and optional transformation functions).
  ///
  /// When [key] or [value] is omitted, each element is cast directly to [K] or
  /// [V].
  factory fromIterable(
    Iterable<Object?> iterable, {
    K Function(Object? element)? key,
    V Function(Object? element)? value,
  }) {
    final result = BiMap<K, V>();
    final keyProvider = key ?? (element) => element as K;
    final valueProvider = value ?? (element) => element as V;
    for (final element in iterable) {
      result[keyProvider(element)] = valueProvider(element);
    }
    return result;
  }

  /// Creates a bi-map from two equal-length iterables.
  ///
  /// Throws an [ArgumentError] if [keys] and [values] have different lengths.
  factory fromIterables(Iterable<K> keys, Iterable<V> values) {
    final result = BiMap<K, V>();
    final keyIterator = keys.iterator;
    final valueIterator = values.iterator;
    var moreKeys = keyIterator.moveNext();
    var moreValues = valueIterator.moveNext();
    while (moreKeys && moreValues) {
      result[keyIterator.current] = valueIterator.current;
      moreKeys = keyIterator.moveNext();
      moreValues = valueIterator.moveNext();
    }
    if (moreKeys || moreValues) {
      throw ArgumentError('Iterables do not have same length');
    }
    return result;
  }

  /// Internal constructor.
  new _(this._forward, this._backward, {required this._isIdentity});

  /// Internal map with associations from `keys` to `values`.
  final Map<K, V> _forward;

  /// Internal map with associations from `values` to `keys`.
  final Map<V, K> _backward;

  final bool _isIdentity;

  /// Returns the inverse bi-map onto the same data.
  BiMap<V, K> get inverse =>
      BiMap<V, K>._(_backward, _forward, isIdentity: _isIdentity);

  /// Returns a forward map onto the same data. This accessor effectively
  /// returns this object, but cast-down to a [Map].
  Map<K, V> get forward => this;

  /// Returns a backward map onto the same data. This accessor effectively
  /// returns the same as [BiMap.inverse], but cast-down to a [Map].
  Map<V, K> get backward => inverse;

  @override
  V? operator [](Object? key) => _forward[key];

  @override
  void operator []=(K key, V value) {
    if (_forward.containsKey(key)) {
      final existing = _forward[key];
      if (_isIdentity ? identical(existing, value) : existing == value) {
        return;
      }
      _backward.remove(_forward.remove(key));
    }
    if (_backward.containsKey(value)) {
      _forward.remove(_backward.remove(value));
    }
    _forward[key] = value;
    _backward[value] = key;
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final existing = _forward[key];
    if (existing != null || _forward.containsKey(key)) {
      return existing as V;
    }
    final value = ifAbsent();
    this[key] = value;
    return value;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    final snapshot = _forward.entries.toList(growable: false);
    for (final entry in snapshot) {
      this[entry.key] = update(entry.key, entry.value);
    }
  }

  @override
  V? remove(Object? key) {
    if (!_forward.containsKey(key)) return null;
    final value = _forward.remove(key);
    _backward.remove(value);
    return value;
  }

  @override
  void clear() {
    _forward.clear();
    _backward.clear();
  }

  @override
  bool containsKey(Object? key) => _forward.containsKey(key);

  @override
  bool containsValue(Object? value) => _backward.containsKey(value);

  @override
  void forEach(void Function(K key, V value) action) =>
      _forward.forEach(action);

  @override
  bool get isEmpty => _forward.isEmpty;

  @override
  bool get isNotEmpty => _forward.isNotEmpty;

  @override
  int get length => _forward.length;

  @override
  Iterable<K> get keys => _forward.keys;

  @override
  Iterable<V> get values => _backward.keys;

  @override
  Iterable<MapEntry<K, V>> get entries => _forward.entries;
}

/// Extension on [Map] to convert to a [BiMap].
extension BiMapOnMapExtension<K, V> on Map<K, V> {
  /// Converts this [Map] to an equivalent [BiMap].
  BiMap<K, V> toBiMap() => BiMap.of(this);
}

/// Extension on [Iterable] to convert to a [BiMap].
extension BiMapOnIterableExtension<E> on Iterable<E> {
  /// Converts this [Iterable] to a [BiMap].
  BiMap<K, V> toBiMap<K, V>({
    K Function(E element)? key,
    V Function(E element)? value,
  }) {
    final result = BiMap<K, V>();
    final keyProvider = key ?? (element) => element as K;
    final valueProvider = value ?? (element) => element as V;
    for (final element in this) {
      result[keyProvider(element)] = valueProvider(element);
    }
    return result;
  }
}
