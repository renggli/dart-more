import 'dart:collection' show ListMixin;

import '../multimap.dart';

/// A multimap that stores values in a [List], and that maintains the insertion
/// order of values of a given key. A [factory] can be provided to create
/// custom value collections.
class ListMultimap<K, V> extends Multimap<K, V, List<V>> {
  /// Creates a [ListMultimap] with the same keys and values as [other].
  factory of(
    Multimap<K, V, Iterable<V>> other, {
    Map<K, List<V>>? map,
    Factory<List<V>>? factory,
  }) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    other.forEach(result.add);
    return result;
  }

  /// Creates a [ListMultimap] with identity keys.
  factory identity({Factory<List<V>>? factory}) =>
      ListMultimap(map: Map.identity(), factory: factory);

  /// Creates a [ListMultimap] with the keys and values from [iterable].
  factory fromIterable(
    Iterable<Object?> iterable, {
    K Function(Object? element)? key,
    V Function(Object? element)? value,
    Map<K, List<V>>? map,
    Factory<List<V>>? factory,
  }) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromIterable(result, iterable, key, value);
    return result;
  }

  /// Creates a [ListMultimap] associating the given [keys] to [values].
  ///
  /// Throws an [ArgumentError] if [keys] and [values] have different lengths.
  factory fromIterables(
    Iterable<K> keys,
    Iterable<V> values, {
    Map<K, List<V>>? map,
    Factory<List<V>>? factory,
  }) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromIterables(result, keys, values);
    return result;
  }

  /// Creates a [ListMultimap] containing the entries of [entries].
  factory fromEntries(
    Iterable<MapEntry<K, V>> entries, {
    Map<K, List<V>>? map,
    Factory<List<V>>? factory,
  }) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromEntries(result, entries);
    return result;
  }

  /// Creates a [ListMultimap] with the keys held in [map] and the values in
  /// collections built with [factory].
  new({Map<K, List<V>>? map, Factory<List<V>>? factory})
    : super(map ?? <K, List<V>>{}, factory ?? _defaultFactory);

  @override
  ListMultimapValues<K, V> lookupValues(K key) =>
      ListMultimapValues<K, V>(this, key);

  @override
  List<V> copyValues(Iterable<V> values) => factory()..addAll(values);
}

class ListMultimapValues<K, V> extends MultimapValues<K, V, List<V>>
    with ListMixin<V> {
  new(super.multimap, super.key);

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
  bool contains(Object? element) {
    refresh();
    return delegate.contains(element);
  }

  @override
  int indexOf(Object? element, [int start = 0]) {
    refresh();
    return element is V ? delegate.indexOf(element, start) : -1;
  }

  @override
  int lastIndexOf(Object? element, [int? start]) {
    refresh();
    return element is V ? delegate.lastIndexOf(element, start) : -1;
  }

  @override
  void add(V element) => update((map, length) {
    final wasEmpty = delegate.isEmpty;
    delegate.add(element);
    if (wasEmpty) {
      map[key] = delegate;
    }
    return 1;
  });

  @override
  void addAll(Iterable<V> iterable) => update((map, length) {
    final elements = snapshotIfAliased(iterable);
    final previousLength = delegate.length;
    delegate.addAll(elements);
    final added = delegate.length - previousLength;
    if (previousLength == 0 && added > 0) {
      map[key] = delegate;
    }
    return added;
  });

  @override
  bool remove(Object? element) => update((map, length) {
    if (!delegate.remove(element)) return 0;
    if (delegate.isEmpty) {
      map.remove(key);
    }
    return -1;
  });

  @override
  void clear() => update((map, length) {
    final previousLength = delegate.length;
    if (previousLength == 0) return 0;
    delegate.clear();
    map.remove(key);
    return -previousLength;
  });

  @override
  void sort([int Function(V a, V b)? compare]) {
    refresh();
    delegate.sort(compare);
  }

  @override
  set length(int newLength) => update((map, length) {
    final previousLength = delegate.length;
    if (previousLength != newLength) {
      delegate.length = newLength;
      if (previousLength == 0 && newLength > 0) {
        map[key] = delegate;
      } else if (newLength == 0) {
        map.remove(key);
      }
      return newLength - previousLength;
    }
    return 0;
  });

  @override
  void polymorphicAdd(V value) => add(value);

  @override
  void polymorphicAddAll(Iterable<V> values) => addAll(values);

  @override
  void polymorphicRemove(V value) => remove(value);

  @override
  void polymorphicClear() => clear();
}

/// Extension on [Map] to convert to a [ListMultimap].
extension ListMultimapOnMapExtension<K, V> on Map<K, V> {
  /// Converts this [Map] to an equivalent [ListMultimap].
  ListMultimap<K, V> toListMultimap({
    Map<K, List<V>>? map,
    Factory<List<V>>? factory,
  }) => ListMultimap<K, V>.fromEntries(entries, map: map, factory: factory);
}

/// Extension on [Iterable] to convert to a [ListMultimap].
extension ListMultimapOnIterableExtension<E> on Iterable<E> {
  /// Converts this [Iterable] to a [ListMultimap].
  ListMultimap<K, V> toListMultimap<K, V>({
    K Function(E element)? key,
    V Function(E element)? value,
    Map<K, List<V>>? map,
    Factory<List<V>>? factory,
  }) {
    final result = ListMultimap<K, V>(map: map, factory: factory);
    fillFromIterable(result, this, key, value);
    return result;
  }
}

List<V> _defaultFactory<V>() => <V>[];
