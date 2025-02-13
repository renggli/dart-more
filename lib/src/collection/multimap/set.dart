import 'dart:collection' show SetMixin;

import '../multimap.dart';

/// A multimap that stores values in a [Set], and that keeps the unique values
/// of a given key. A `factory` can be provided to create custom value
/// collections.
class SetMultimap<K, V> extends Multimap<K, V, Set<V>> {
  /// Creates a [SetMultimap] with the same keys and values as [other].
  factory SetMultimap.of(
    Multimap<K, V, Iterable<V>> other, {
    Map<K, Set<V>>? map,
    Factory<Set<V>>? factory,
  }) {
    final result = SetMultimap<K, V>(map: map, factory: factory);
    other.forEach(result.add);
    return result;
  }

  /// Creates a [SetMultimap] with identity keys.
  factory SetMultimap.identity({Factory<Set<V>>? factory}) =>
      SetMultimap(map: Map.identity(), factory: factory);

  /// Creates a [SetMultimap] with the keys and values computed from [iterable].
  factory SetMultimap.fromIterable /*<E>*/ (
    Iterable<Object?> /*<E>*/ iterable, {
    K Function(Object? /*E*/ element)? key,
    V Function(Object? /*E*/ element)? value,
    Map<K, Set<V>>? map,
    Factory<Set<V>>? factory,
  }) {
    final result = SetMultimap<K, V>(map: map, factory: factory);
    fillFromIterable(result, iterable, key, value);
    return result;
  }

  // Creates a [SetMultimap] associating the given [keys] to [values].
  factory SetMultimap.fromIterables(
    Iterable<K> keys,
    Iterable<V> values, {
    Map<K, Set<V>>? map,
    Factory<Set<V>>? factory,
  }) {
    final result = SetMultimap<K, V>(map: map, factory: factory);
    fillFromIterables(result, keys, values);
    return result;
  }

  /// Creates a [SetMultimap] containing the entries of [entries].
  factory SetMultimap.fromEntries(
    Iterable<MapEntry<K, V>> entries, {
    Map<K, Set<V>>? map,
    Factory<Set<V>>? factory,
  }) {
    final result = SetMultimap<K, V>(map: map, factory: factory);
    fillFromEntries(result, entries);
    return result;
  }

  /// Creates an empty [SetMultimap] with the keys held in [map] and the values
  /// in a collection built with [factory].
  SetMultimap({Map<K, Set<V>>? map, Factory<Set<V>>? factory})
    : super(map ?? <K, Set<V>>{}, factory ?? defaultFactory);

  @override
  SetMultimapValues<K, V> lookupValues(K key) =>
      SetMultimapValues<K, V>(this, key);
}

class SetMultimapValues<K, V> extends MultimapValues<K, V, Set<V>>
    with SetMixin<V> {
  SetMultimapValues(super.multimap, super.key);

  @override
  bool add(V value) => update((map, length) {
    final wasEmpty = delegate.isEmpty;
    final result = delegate.add(value);
    if (result) {
      if (wasEmpty) {
        map[key] = delegate;
      }
      return 1;
    }
    return 0;
  });

  @override
  V? lookup(Object? element) {
    refresh();
    return delegate.lookup(element);
  }

  @override
  bool remove(Object? value) => update((map, length) {
    final result = delegate.remove(value);
    if (result) {
      if (delegate.isEmpty) {
        map.remove(key);
      }
      return -1;
    }
    return 0;
  });

  @override
  void polymorphicAdd(V value) => add(value);

  @override
  void polymorphicRemove(V value) => remove(value);

  @override
  void polymorphicClear() => clear();
}

extension SetMultimapOnMapExtension<K, V> on Map<K, V> {
  /// Converts this [Map] to an equivalent [SetMultimap].
  SetMultimap<K, V> toSetMultimap({
    Map<K, Set<V>>? map,
    Factory<Set<V>>? factory,
  }) => SetMultimap<K, V>.fromEntries(entries, map: map, factory: factory);
}

extension SetMultimapOnIterableExtension<E> on Iterable<E> {
  /// Converts this [Iterable] to a [SetMultimap].
  SetMultimap<K, V> toSetMultimap<K, V>({
    K Function(E element)? key,
    V Function(E element)? value,
    Map<K, Set<V>>? map,
    Factory<Set<V>>? factory,
  }) {
    final keyProvider = key ?? (element) => element as K;
    final valueProvider = value ?? (element) => element as V;
    return SetMultimap<K, V>.fromIterables(
      this.map(keyProvider),
      this.map(valueProvider),
      map: map,
      factory: factory,
    );
  }
}

Set<V> defaultFactory<V>() => <V>{};
