import 'dart:async' show Future, FutureOr;

import 'package:clock/clock.dart';

import '../printer/object/object.dart';
import 'cache.dart';
import 'item.dart';
import 'loader.dart';

/// A cache that expires after a certain amount of time.
class ExpiryCache<K, V> extends Cache<K, V> {
  /// Creates an expiry cache with the given [loader], [updateExpiry], and
  /// [accessExpiry].
  new(this.loader, this.updateExpiry, this.accessExpiry) {
    if (updateExpiry == null && accessExpiry == null) {
      throw ArgumentError('Either update or access expiry must be provided.');
    }
    if (updateExpiry case final update? when update <= Duration.zero) {
      throw ArgumentError.value(
        update,
        'updateExpiry',
        'Update expiry must be positive.',
      );
    }
    if (accessExpiry case final access? when access <= Duration.zero) {
      throw ArgumentError.value(
        access,
        'accessExpiry',
        'Access expiry must be positive.',
      );
    }
  }

  /// The loader function for cache misses.
  final Loader<K, V> loader;

  /// The duration after which an updated entry expires.
  final Duration? updateExpiry;

  /// The duration after which an accessed entry expires.
  final Duration? accessExpiry;

  /// The map of cached items.
  final Map<K, ExpiryCacheItem<V>> cached = {};

  @override
  Future<V> get(K key) async {
    final now = clock.now();
    var item = cached[key];
    if (item == null || item.isExpired(now)) {
      cached.remove(key);
      item = cached[key] = ExpiryCacheItem(
        loader(key),
        updateDeadline: _deadline(now, updateExpiry),
        accessDeadline: _deadline(now, accessExpiry),
      );
    } else {
      item.refreshAccess(now, accessExpiry);
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
  Future<V?> getIfPresent(K key) async {
    final now = clock.now();
    final item = cached[key];
    if (item == null) {
      return null;
    } else if (item.isExpired(now)) {
      cached.remove(key);
      return null;
    }
    item.refreshAccess(now, accessExpiry);
    return await item.value;
  }

  @override
  Future<V> set(K key, FutureOr<V> value) async {
    final now = clock.now();
    final item = cached[key] = ExpiryCacheItem(
      value,
      updateDeadline: _deadline(now, updateExpiry),
      accessDeadline: _deadline(now, accessExpiry),
    );
    try {
      return await item.value;
    } catch (_) {
      if (identical(cached[key], item)) {
        cached.remove(key);
      }
      rethrow;
    }
  }

  static DateTime? _deadline(DateTime now, Duration? duration) =>
      duration != null ? now.add(duration) : null;

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

/// An item stored in an [ExpiryCache] with expiration deadlines.
class ExpiryCacheItem<V> extends CacheItem<V> {
  /// Creates an expiry cache item with the given deadlines.
  new(super.value, {this.updateDeadline, this.accessDeadline});

  /// The deadline after which this item expires due to update time.
  DateTime? updateDeadline;

  /// The deadline after which this item expires due to access time.
  DateTime? accessDeadline;

  /// The earlier expiration deadline of this item.
  DateTime get expiry {
    final update = updateDeadline;
    final access = accessDeadline;
    if (update != null && access != null) {
      return update.isBefore(access) ? update : access;
    }
    return (update ?? access)!;
  }

  /// Whether this item has expired given the current time [now].
  bool isExpired(DateTime now) {
    final update = updateDeadline;
    final access = accessDeadline;
    return (update != null && now.isAfter(update)) ||
        (access != null && now.isAfter(access));
  }

  /// Refreshes the update deadline from [now] and [duration].
  void refreshUpdate(DateTime now, Duration? duration) {
    if (duration != null) {
      updateDeadline = now.add(duration);
    }
  }

  /// Refreshes the access deadline from [now] and [duration].
  void refreshAccess(DateTime now, Duration? duration) {
    if (duration != null) {
      accessDeadline = now.add(duration);
    }
  }
}
