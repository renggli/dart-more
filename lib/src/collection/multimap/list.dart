library more.collection.multimap.list;

import 'dart:collection' show ListMixin;

import '../multimap.dart';

/// A multimap that stores values in a [List], and that maintains the insertion
/// order of values of a given key. A `factory` can be provided to create
/// custom value collections.
class ListMultimap<K, V> extends Multimap<K, V, List<V>> {
  /// Creates a [ListMultimap] with the same keys and values as [other].
  factory ListMultimap.of(Multimap<K, V, Iterable<V>> other,
      {Map<K, List<V>> map, Factory<List<V>> factory}) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    other.forEach(result.add);
    return result;
  }

  /// Creates a [ListMultimap] with identity keys.
  factory ListMultimap.identity({Factory<List<V>> factory}) =>
      ListMultimap(map: Map.identity(), factory: factory);

  /// Creates a [ListMultimap] with the keys and values from [iterable].
  factory ListMultimap.fromIterable(Iterable iterable,
      {K key(element), // ignore: use_function_type_syntax_for_parameters
      V value(element), // ignore: use_function_type_syntax_for_parameters
      Map<K, List<V>> map,
      Factory<List<V>> factory}) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromIterable(result, iterable, key, value);
    return result;
  }

  // Creates a [ListMultimap] associating the given [keys] to [values].
  factory ListMultimap.fromIterables(Iterable<K> keys, Iterable<V> values,
      {Map<K, List<V>> map, Factory<List<V>> factory}) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromIterables(result, keys, values);
    return result;
  }

  /// Creates a [ListMultimap] containing the entries of [entries].
  factory ListMultimap.fromEntries(Iterable<MapEntry<K, V>> entries,
      {Map<K, List<V>> map, Factory<List<V>> factory}) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromEntries(result, entries);
    return result;
  }

  /// Creates an empty [ListMultimap] with the keys held in [map] and the values
  /// in a collection built with [factory].
  ListMultimap({Map<K, List<V>> map, Factory<List<V>> factory})
      : super(map ?? <K, List<V>>{}, factory ?? defaultFactory);

  @override
  MultimapValues<K, V, List<V>> operator [](K key) =>
      ListMultimapValues<K, V>(this, key);
}

class ListMultimapValues<K, V> extends MultimapValues<K, V, List<V>>
    with ListMixin<V> {
  ListMultimapValues(ListMultimap<K, V> multimap, K key) : super(multimap, key);

  @override
  V operator [](int index) {
    refresh();
    return delegate[index];
  }

  @override
  void operator []=(int index, V value) {
    refresh();
    delegate[index] = value;
  }

  @override
  set length(int newLength) {
    update((map, length) {
      final previousLength = delegate.length;
      if (previousLength != newLength) {
        if (previousLength == 0) {
          map[key] = delegate;
        }
        delegate.length = newLength;
        if (newLength == 0) {
          map.remove(key);
        }
        return newLength - previousLength;
      }
      return 0;
    });
  }

  @override
  void polymorphicAdd(V value) => add(value);

  @override
  void polymorphicRemove(V value) => remove(value);

  @override
  void polymorphicClear() => clear();
}

List<V> defaultFactory<V>() => <V>[];
