import 'dart:async' show Future, FutureOr;

import 'package:clock/clock.dart';

import '../../cache.dart';
import 'item.dart';
import 'loader.dart';

/// A cache that expires after a certain amount of time.
class ExpiryCache<K, V> extends Cache<K, V> {
  final Loader<K, V> loader;

  final Duration createExpiry;

  final Duration updateExpiry;

  final Duration accessExpiry;

  final Map<K, ExpiryCacheItem<V>> cached = {};

  ExpiryCache(this.loader, this.updateExpiry, this.accessExpiry)
      : createExpiry =
            accessExpiry < updateExpiry ? updateExpiry : accessExpiry;

  @override
  Future<V> get(K key) async {
    final now = clock.now();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = ExpiryCacheItem(loader(key), now.add(createExpiry));
    } else if (item.isExpired(now)) {
      item.value = loader(key);
      item.expiry = max(item.expiry, now.add(updateExpiry));
    } else {
      item.expiry = max(item.expiry, now.add(accessExpiry));
    }
    return item.value;
  }

  @override
  Future<V?> getIfPresent(K key) async {
    final now = clock.now();
    final item = cached[key];
    if (item == null) {
      return null;
    } else if (item.isExpired(now)) {
      cached.remove(key);
      return null;
    } else {
      item.expiry = max(item.expiry, now.add(accessExpiry));
    }
    return item.value;
  }

  @override
  Future<V> set(K key, FutureOr<V> value) async {
    final now = clock.now();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = ExpiryCacheItem(value, now.add(createExpiry));
    } else {
      item.value = value;
      item.expiry = max(item.expiry, now.add(updateExpiry));
    }
    return item.value;
  }

  @override
  Future<int> size() async => cached.length;

  @override
  Future<void> invalidate(K key) async => cached.remove(key);

  @override
  Future<void> invalidateAll() async => cached.clear();

  @override
  Future<int> reap() async {
    final now = clock.now();
    final expired = <K>[];
    cached.forEach((key, value) {
      if (value.isExpired(now)) {
        expired.add(key);
      }
    });
    expired.forEach(cached.remove);
    return expired.length;
  }
}

class ExpiryCacheItem<V> extends CacheItem<V> {
  DateTime expiry;

  ExpiryCacheItem(FutureOr<V> value, this.expiry) : super(value);

  bool isExpired(DateTime now) => now.isAfter(expiry);
}

DateTime max(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
