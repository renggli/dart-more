library more.collection.multimap;

import 'dart:collection';

import 'package:meta/meta.dart';

/// Factory to build values of type [T].
typedef Factory<T> = T Function();

/// A collection maintaining a mapping between keys and multiple values.
abstract class Multimap<K, V, VS extends Iterable<V>> {
  /// Underlying map with associations from `key` to `values`.
  final Map<K, VS> _map;

  /// Internal counter for values.
  int _length = 0;

  /// Factory method to build `values` collection.
  final VS Function() _factory;

  /// Internal factory constructor.
  Multimap(this._map, this._factory);

  /// The number of values in this multimap.
  int get length => _length;

  /// Returns true if there are no values in this multimap.
  bool get isEmpty => _length == 0;

  /// Returns true if there is at leas one value in this multimap.
  bool get isNotEmpty => _length > 0;

  /// The unique keys of this multimap.
  Iterable<K> get keys => _map.keys;

  /// The values of this multimap.
  Iterable<V> get values => _map.values.expand((values) => values);

  /// Applies [callback] to each key/value of this multimap.
  void forEach(void Function(K key, V value) callback) {
    for (final key in keys) {
      for (final value in this[key]) {
        callback(key, value);
      }
    }
  }

  /// Returns true if this map contains the given [key].
  bool containsKey(K key) => _map.containsKey(key);

  /// Returns true if this map contains the given [value].
  bool containsValue(V value) => values.contains(value);

  /// Returns the values for the given [key].
  MultimapValues<K, V, VS> operator [](K key);

  /// Adds an association from [key] to [value].
  void add(K key, V value) => this[key].polymorphicAdd(value);

  /// Adds associations from [key] to each of [values].
  void addAll(K key, Iterable<V> values) => this[key].polymorphicAddAll(values);

  /// Removes one association from [key] to [value].
  void remove(K key, V value) => this[key].polymorphicRemove(value);

  /// Removes associations from [key] to each of [values].
  void removeAll(K key, [Iterable<V> values]) => values == null
      ? this[key].polymorphicClear()
      : this[key].polymorphicRemoveAll(values);

  /// Removes all values from this multimap.
  void clear() {
    for (final key in List.of(keys)) {
      this[key].polymorphicClear();
    }
    _map.clear();
    _length = 0;
  }

  /// Replaces the [key] with a single [value].
  void replace(K key, V value) => this[key]
    ..polymorphicClear()
    ..polymorphicAdd(value);

  /// Replaces the [key] with each of the [values].
  void replaceAll(K key, Iterable<V> values) => this[key]
    ..polymorphicClear()
    ..polymorphicAddAll(values);

  /// Returns a view onto the underlying map.
  Map<K, VS> asMap() => MultimapAsMap(this);
}

// Internal callback to update the data of a multimap. Receives the current
// [map] and total [length], returns the change in length.
typedef UpdateCallback<K, V, VS extends Iterable<V>> = int Function(
    Map<K, VS> map, int length);

abstract class MultimapValues<K, V, VS extends Iterable<V>>
    with IterableMixin<V> {
  @protected
  final Multimap<K, V, VS> multimap;

  final K key;

  @protected
  VS delegate;

  MultimapValues(this.multimap, this.key)
      : delegate = multimap._map[key] ?? multimap._factory();

  @override
  int get length {
    refresh();
    return delegate.length;
  }

  @override
  Iterator<V> get iterator {
    refresh();
    return delegate.iterator;
  }

  @protected
  void refresh() {
    if (delegate.isEmpty) {
      final current = multimap._map[key];
      if (current != null) {
        delegate = current;
      }
    }
  }

  @protected
  bool update(UpdateCallback<K, V, VS> callback) {
    refresh();
    final change = callback(multimap._map, multimap._length);
    multimap._length += change;
    return change != 0;
  }

  @protected
  void polymorphicAdd(V value);

  @protected
  void polymorphicAddAll(Iterable<V> values) => values.forEach(polymorphicAdd);

  @protected
  void polymorphicRemove(V value);

  @protected
  void polymorphicRemoveAll(Iterable<V> values) =>
      values.forEach(polymorphicRemove);

  @protected
  void polymorphicClear();
}

@immutable
class MultimapAsMap<K, V, VS extends Iterable<V>> extends MapBase<K, VS> {
  final Multimap<K, V, VS> _multimap;

  MultimapAsMap(this._multimap);

  @override
  int get length => _multimap._map.length;

  @override
  VS operator [](Object key) => _multimap[key] as VS; // ignore: avoid_as

  @override
  void operator []=(K key, VS value) => _multimap.replaceAll(key, value);

  @override
  void clear() => _multimap.clear();

  @override
  Iterable<K> get keys => _multimap.keys;

  @override
  VS remove(Object key) {
    final result = this[key];
    _multimap.removeAll(key);
    return result;
  }
}

// Internal helper to populate a [multimap] from an [Iterable].
void fillFromIterable<K, V, VS extends Iterable<V>>(
  Multimap<K, V, VS> multimap,
  Iterable iterable,
  // ignore: use_function_type_syntax_for_parameters, type_annotate_public_apis
  K key(element),
  // ignore: use_function_type_syntax_for_parameters, type_annotate_public_apis
  V value(element),
) {
  key ??= (x) => x;
  value ??= (x) => x;
  for (final element in iterable) {
    multimap.add(key(element), value(element));
  }
}

// Internal helper to populate a [multimap] from [keys] and [values].
void fillFromIterables<K, V, VS extends Iterable<V>>(
    Multimap<K, V, VS> multimap, Iterable<K> keys, Iterable<V> values) {
  final keyIterator = keys.iterator;
  final valueIterator = values.iterator;
  var hasNextKey = keyIterator.moveNext();
  var hasNextValue = valueIterator.moveNext();
  while (hasNextKey && hasNextValue) {
    multimap.add(keyIterator.current, valueIterator.current);
    hasNextKey = keyIterator.moveNext();
    hasNextValue = valueIterator.moveNext();
  }
  if (hasNextKey || hasNextValue) {
    throw ArgumentError('Iterables do not have same length.');
  }
}

// Internal helper to populate a [multimap] from an [Iterable] of entries.
void fillFromEntries<K, V, VS extends Iterable<V>>(
    Multimap<K, V, VS> multimap, Iterable<MapEntry<K, V>> entries) {
  for (final entry in entries) {
    multimap.add(entry.key, entry.value);
  }
}
