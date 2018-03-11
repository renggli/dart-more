library more.cache.expiry;

import 'dart:async' show Future, FutureOr;

import 'package:more/cache.dart';
import 'package:more/src/cache/clock.dart';
import 'package:more/src/cache/item.dart';
import 'package:more/src/cache/loader.dart';

/// A cache that expires after a certain amount of time.
class ExpiryCache<K, V> extends Cache<K, V> {
  final Loader<K, V> loader;

  final Clock clock;

  final Duration updateExpiry;

  final Duration accessExpiry;

  final Map<K, ExpiryCacheItem<V>> cached = {};

  ExpiryCache(this.loader, this.clock, this.updateExpiry, this.accessExpiry);

  @override
  Future<V> get(K key) async {
    var now = clock();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = new ExpiryCacheItem(loader(key), now);
    } else if (item.isExpired(now, updateExpiry, accessExpiry)) {
      item.value = loader(key);
      item.lastAccess = item.lastUpdate = now;
    } else {
      item.lastAccess = now;
    }
    return item.value;
  }

  @override
  Future<V> getIfPresent(K key) async {
    var now = clock();
    var item = cached[key];
    if (item == null) {
      return null;
    } else if (item.isExpired(now, updateExpiry, accessExpiry)) {
      cached.remove(key);
      return null;
    } else {
      item.lastAccess = now;
    }
    return item.value;
  }

  @override
  Future<V> set(K key, V value) async {
    var now = clock();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = new ExpiryCacheItem(value, now);
    } else {
      item.lastUpdate = item.lastAccess = now;
      item.value = value;
    }
    return item.value;
  }

  @override
  Future<int> size() async => cached.length;

  @override
  Future invalidate(K key) async => cached.remove(key);

  @override
  Future invalidateAll() async => cached.clear();

  @override
  Future<int> reap() async {
    var now = clock();
    var expired = <K>[];
    cached.forEach((key, value) {
      if (value.isExpired(now, updateExpiry, accessExpiry)) {
        expired.add(key);
      }
    });
    expired.forEach(cached.remove);
    return expired.length;
  }
}

class ExpiryCacheItem<V> extends CacheItem<V> {
  DateTime lastUpdate;
  DateTime lastAccess;

  ExpiryCacheItem(FutureOr<V> value, DateTime now) : super(value) {
    lastUpdate = lastAccess = now;
  }

  bool isExpired(DateTime now, Duration updateExpiry, Duration accessExpiry) {
    if (updateExpiry != null && lastUpdate.add(updateExpiry).isBefore(now)) {
      return true;
    }
    if (accessExpiry != null && lastAccess.add(accessExpiry).isBefore(now)) {
      return true;
    }
    return false;
  }
}
