library more.cache.expiry;

import 'dart:async';

import 'package:more/cache.dart';
import 'package:more/src/cache/item.dart';
import 'package:more/src/cache/loader.dart';

/// Expiry cache.
class ExpiryCache<K, V> extends Cache<K, V> {

  final Loader<K, V> loader;

  final Duration updateExpiry;

  final Duration accessExpiry;

  final Duration expiryInterval;

  final Map<K, ExpiryCacheItem<V>> cached = new Map();

  DateTime lastExpiry = new DateTime.now();

  ExpiryCache(this.loader, this.updateExpiry, this.accessExpiry, this.expiryInterval);

  @override
  Future<V> get(K key) async {
    expire();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = new ExpiryCacheItem(loader(key));
    } else {
      item.lastAccess = new DateTime.now();
    }
    return item.value;
  }

  @override
  Future<V> getIfPresent(K key) async {
    expire();
    var item = cached[key];
    if (item == null) {
      return null;
    }
    item.lastAccess = new DateTime.now();
    return item.value;
  }

  @override
  Future<V> set(K key, V value) async {
    expire();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = new ExpiryCacheItem(value);
    } else {
      item.lastUpdate = new DateTime.now();
      item.value = value;
    }
    return item.value;
  }

  @override
  Future<int> size() async {
    expire();
    return cached.length;
  }

  @override
  Future invalidate(K key) async => cached.remove(key);

  @override
  Future invalidateAll() async => cached.clear();

  int expire() {
    var currentTime = new DateTime.now();
    if (lastExpiry.add(expiryInterval).isBefore(currentTime)) {
      var expiredKeys = new List();
      cached.forEach((key, value) {
        var isExpired =
            (updateExpiry != null && value.lastUpdate.add(updateExpiry).isBefore(currentTime)) ||
            (accessExpiry != null && value.lastAccess.add(accessExpiry).isBefore(currentTime));
        if (isExpired) {
          expiredKeys.add(key);
        }
      });
      expiredKeys.forEach(cached.remove);
      lastExpiry = new DateTime.now();
      return expiredKeys.length;
    }
    return 0;
  }

}

class ExpiryCacheItem<V> extends CacheItem<V> {
  DateTime lastUpdate;
  DateTime lastAccess;

  ExpiryCacheItem(FutureOr<V> value) : super(value) {
    lastUpdate = lastAccess = new DateTime.now();
  }
}