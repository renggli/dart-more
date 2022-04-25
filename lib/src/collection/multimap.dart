import 'dart:collection';

import 'package:meta/meta.dart';

/// Factory to build values of type [T].
typedef Factory<T> = T Function();

/// A collection maintaining a mapping between keys and multiple values.
abstract class Multimap<K, V, VS extends Iterable<V>> {
  /// Internal factory constructor.
  Multimap(this._map, this._factory);

  /// Underlying map with associations from `keys` to `values`.
  final Map<K, VS> _map;

  /// Internal counter for total number of values.
  int _length = 0;

  /// Factory method to build `value` collections.
  final VS Function() _factory;

  /// Returns the total number of values in this multimap.
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
    for (final entry in _map.entries) {
      for (final value in entry.value) {
        callback(entry.key, value);
      }
    }
  }

  /// Returns true if this map contains the given [key].
  bool containsKey(K? key) => _map.containsKey(key);

  /// Returns true if this map contains the given [value].
  bool containsValue(V? value) {
    for (final values in _map.values) {
      if (values.contains(value)) {
        return true;
      }
    }
    return false;
  }

  /// Returns the values for the given [key].
  VS operator [](K key) => lookupValues(key) as VS;

  /// Adds an association from [key] to [value].
  void add(K key, V value) => lookupValues(key).polymorphicAdd(value);

  /// Adds associations from [key] to each of [values].
  void addAll(K key, Iterable<V> values) =>
      lookupValues(key).polymorphicAddAll(values);

  /// Removes one association from [key] to [value].
  void remove(K key, V value) => lookupValues(key).polymorphicRemove(value);

  /// Removes associations from [key] to each of [values].
  void removeAll(K key, [Iterable<V>? values]) => values == null
      ? lookupValues(key).polymorphicClear()
      : lookupValues(key).polymorphicRemoveAll(values);

  /// Replaces the [key] with a single [value].
  void replace(K key, V value) => lookupValues(key)
    ..polymorphicClear()
    ..polymorphicAdd(value);

  /// Replaces the [key] with each of the [values].
  void replaceAll(K key, Iterable<V> values) => lookupValues(key)
    ..polymorphicClear()
    ..polymorphicAddAll(values);

  /// Removes all values from this multimap.
  void clear() {
    for (final key in List.of(keys)) {
      lookupValues(key).polymorphicClear();
    }
    _map.clear();
    _length = 0;
  }

  /// Returns a view onto the underlying map.
  Map<K, VS> asMap() => MultimapAsMap(this);

  @override
  String toString() => asMap().toString();

  @protected
  MultimapValues<K, V, VS> lookupValues(K key);
}

// Internal callback to update the data of a multimap. Receives the current
// [map] and total [length], returns the change in length.
typedef UpdateCallback<K, V, VS extends Iterable<V>> = int Function(
    Map<K, VS> map, int length);

// Internal wrapper around the values at a specific key of a [Multimap].
abstract class MultimapValues<K, V, VS extends Iterable<V>>
    with IterableMixin<V> {
  MultimapValues(this.multimap, this.key)
      : delegate = multimap._map[key] ?? multimap._factory();

  @protected
  final Multimap<K, V, VS> multimap;

  final K key;

  @protected
  VS delegate;

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

// Internal wrapper around the underlying [Map] of a [Multimap].
@immutable
class MultimapAsMap<K, V, VS extends Iterable<V>> extends MapBase<K, VS> {
  MultimapAsMap(this._multimap);

  final Multimap<K, V, VS> _multimap;

  @override
  int get length => _multimap._map.length;

  @override
  VS? operator [](Object? key) => key is K ? _multimap[key] : null;

  @override
  void operator []=(K key, VS value) => _multimap.replaceAll(key, value);

  @override
  void clear() => _multimap.clear();

  @override
  Iterable<K> get keys => _multimap.keys;

  @override
  VS? remove(Object? key) {
    if (key is K) {
      final result = this[key];
      _multimap.removeAll(key);
      return result;
    } else {
      return null;
    }
  }
}

// Internal helper to populate a [multimap] from an [Iterable].
void fillFromIterable<K, V, VS extends Iterable<V>, E>(
  Multimap<K, V, VS> multimap,
  Iterable<E> iterable,
  K Function(E element)? key,
  V Function(E element)? value,
) {
  key ??= (x) => x as K;
  value ??= (x) => x as V;
  for (final element in iterable) {
    multimap.add(key(element), value(element));
  }
}

// Internal helper to populate a [multimap] from [keys] and [values].
void fillFromIterables<K, V, VS extends Iterable<V>>(
    Multimap<K, V, VS> multimap, Iterable<K> keys, Iterable<V> values) {
  final keyIterator = keys.iterator;
  final valueIterator = values.iterator;
  var moreKeys = keyIterator.moveNext();
  var moreValues = valueIterator.moveNext();
  while (moreKeys && moreValues) {
    multimap.add(keyIterator.current, valueIterator.current);
    moreKeys = keyIterator.moveNext();
    moreValues = valueIterator.moveNext();
  }
  if (moreKeys || moreValues) {
    throw ArgumentError('Iterables do not have same length');
  }
}

// Internal helper to populate a [multimap] from an [Iterable] of entries.
void fillFromEntries<K, V, VS extends Iterable<V>>(
    Multimap<K, V, VS> multimap, Iterable<MapEntry<K, V>> entries) {
  for (final entry in entries) {
    multimap.add(entry.key, entry.value);
  }
}
