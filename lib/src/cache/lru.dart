library more.cache.lru;

import 'dart:async' show Future;

import '../../cache.dart';
import 'item.dart';
import 'loader.dart';

/// Least Recently Used (LRU) cache.
class LruCache<K, V> extends Cache<K, V> {
  final Loader<K, V> loader;

  final int maximumSize;

  final Map<K, CacheItem<V>> cached = {};

  LruCache(this.loader, this.maximumSize);

  @override
  Future<V> getIfPresent(K key) async => promote(key)?.value;

  @override
  Future<V> get(K key) async {
    var item = promote(key);
    if (item == null) {
      item = cached[key] = CacheItem(loader(key));
      cleanUp();
    }
    return item.value;
  }

  @override
  Future<V> set(K key, V value) async {
    var item = promote(key);
    if (item == null) {
      item = cached[key] = CacheItem(value);
      cleanUp();
    } else {
      item.value = value;
    }
    return value;
  }

  @override
  Future<int> size() async => cached.length;

  @override
  Future<void> invalidate(K key) async => cached.remove(key);

  @override
  Future<void> invalidateAll() async => cached.clear();

  @override
  Future<int> reap() async => 0;

  CacheItem<V> promote(K key) {
    final item = cached.remove(key);
    if (item != null) {
      cached[key] = item;
    }
    return item;
  }

  void cleanUp() {
    while (cached.length > maximumSize) {
      cached.remove(cached.keys.first);
    }
  }
}
