import 'dart:async' show Future, FutureOr;

import 'package:clock/clock.dart';

import '../../printer.dart';
import 'cache.dart';
import 'item.dart';
import 'loader.dart';

/// A cache that expires after a certain amount of time.
class ExpiryCache<K, V> extends Cache<K, V> {
  ExpiryCache(this.loader, this.updateExpiry, this.accessExpiry)
      : assert(updateExpiry != null || accessExpiry != null,
            'Either update or access expiry must be provided.'),
        assert(updateExpiry == null || updateExpiry > Duration.zero,
            'Update expiry must be positive.'),
        assert(accessExpiry == null || accessExpiry > Duration.zero,
            'Access expiry must be positive.');

  final Loader<K, V> loader;

  final Duration? updateExpiry;

  final Duration? accessExpiry;

  final Map<K, ExpiryCacheItem<V>> cached = {};

  @override
  Future<V> get(K key) async {
    final now = clock.now();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = ExpiryCacheItem(loader(key), now);
      item.refreshExpiry(now, updateExpiry);
    } else if (item.isExpired(now)) {
      item.value = loader(key);
      item.refreshExpiry(now, updateExpiry);
    }
    item.refreshExpiry(now, accessExpiry);
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
    }
    item.refreshExpiry(now, accessExpiry);
    return item.value;
  }

  @override
  Future<V> set(K key, FutureOr<V> value) async {
    final now = clock.now();
    var item = cached[key];
    if (item == null) {
      item = cached[key] = ExpiryCacheItem(value, now);
    } else {
      item.value = value;
    }
    item.refreshExpiry(now, updateExpiry);
    item.refreshExpiry(now, accessExpiry);
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

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(cached.length, name: 'size')
    ..addValue(updateExpiry, name: 'updateExpiry')
    ..addValue(accessExpiry, name: 'accessExpiry');
}

class ExpiryCacheItem<V> extends CacheItem<V> {
  ExpiryCacheItem(FutureOr<V> value, this.expiry) : super(value);

  DateTime expiry;

  bool isExpired(DateTime now) => now.isAfter(expiry);

  void refreshExpiry(DateTime now, Duration? duration) {
    if (duration != null) {
      final updated = now.add(duration);
      if (updated.isAfter(expiry)) {
        expiry = updated;
      }
    }
  }
}
