import 'dart:async' show Future, FutureOr;

import '../printer/object/object.dart';
import 'cache.dart';
import 'item.dart';
import 'loader.dart';

/// Least Recently Used (LRU) cache.
class LruCache<K, V> extends Cache<K, V> {
  /// Creates an LRU cache with the given [loader] and [maximumSize].
  new(this.loader, this.maximumSize) {
    RangeError.checkNotNegative(maximumSize - 1, 'maximumSize');
  }

  /// The loader function for cache misses.
  final Loader<K, V> loader;

  /// The maximum number of entries allowed in the cache.
  final int maximumSize;

  /// The map of cached items.
  final Map<K, CacheItem<V>> cached = {};

  @override
  Future<V?> getIfPresent(K key) async => await promote(key)?.value;

  @override
  Future<V> get(K key) async {
    var item = promote(key);
    if (item == null) {
      item = cached[key] = CacheItem(loader(key));
      cleanUp();
    }
    try {
      return await item.value;
    } catch (_) {
      if (identical(cached[key], item)) {
        cached.remove(key);
      }
      rethrow;
    }
  }

  @override
  Future<V> set(K key, FutureOr<V> value) async {
    var item = promote(key);
    if (item == null) {
      item = cached[key] = CacheItem(value);
      cleanUp();
    } else {
      item.value = value;
    }
    return await value;
  }

  @override
  Future<int> size() async => cached.length;

  @override
  Future<void> invalidate(K key) async => cached.remove(key);

  @override
  Future<void> invalidateAll([Iterable<K>? keys]) async {
    if (keys != null) {
      for (final key in keys) {
        cached.remove(key);
      }
    } else {
      cached.clear();
    }
  }

  @override
  Future<int> reap() async => 0;

  /// Promotes the item associated with [key] according to the caching strategy.
  CacheItem<V>? promote(K key) {
    final item = cached.remove(key);
    if (item != null) {
      cached[key] = item;
    }
    return item;
  }

  /// Removes entries that exceed [maximumSize].
  void cleanUp() {
    while (cached.length > maximumSize) {
      cached.remove(cached.keys.first);
    }
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(cached.length, name: 'size')
    ..addValue(maximumSize, name: 'maximumSize');
}
