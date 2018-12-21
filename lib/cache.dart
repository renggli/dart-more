library more.collection.cache;

import 'dart:async' show Future;

import 'package:more/src/cache/clock.dart';
import 'package:more/src/cache/empty.dart';
import 'package:more/src/cache/expiry.dart';
import 'package:more/src/cache/fifo.dart';
import 'package:more/src/cache/loader.dart';
import 'package:more/src/cache/lru.dart';

export 'package:more/src/cache/clock.dart';
export 'package:more/src/cache/delegate.dart';
export 'package:more/src/cache/loader.dart';

abstract class Cache<K, V> {
  /// Constructs an empty or null cache, useful mostly for testing.
  ///
  /// The [loader] defines the function to construct items for the cache.
  factory Cache.empty({Loader<K, V> loader}) {
    if (loader == null) {
      throw ArgumentError.notNull('loader');
    }
    return EmptyCache<K, V>(loader);
  }

  /// Constructs an expiry cache.
  ///
  /// The [loader] defines the function to construct items for the cache.
  ///
  /// [updateExpiry] is the duration after which a loaded or set item expires.
  /// [accessExpiry] is the maximal duration an item does not expire without
  /// being accessed. Whatever happens first, causes the expiration. One of the
  /// duration can be left `null`, if you don' care.
  ///
  /// Note that cached items do not magically disappear when they expire.
  /// Manually call [reap()], or setup a timer to regularly free items.
  factory Cache.expiry(
      {Loader<K, V> loader,
      Clock clock,
      Duration updateExpiry,
      Duration accessExpiry}) {
    if (loader == null) {
      throw ArgumentError.notNull('loader');
    }
    if (updateExpiry == null && accessExpiry == null) {
      throw ArgumentError(
          "Either 'accessExpiry' or 'updateExpiry' must be provided.");
    }
    if (updateExpiry != null && updateExpiry.inMicroseconds <= 0) {
      throw ArgumentError("Negative 'updateExpire' provided.");
    }
    if (accessExpiry != null && accessExpiry.inMicroseconds <= 0) {
      throw ArgumentError("Negative 'updateExpire' provided.");
    }
    return ExpiryCache<K, V>(
        loader, clock ?? systemClock, updateExpiry, accessExpiry);
  }

  /// Constructs a First-in/First-out (FIFO) cache.
  ///
  /// The [loader] defines the function to construct items for the cache; and
  /// [maximumSize] defines the maximum number of items cached.
  factory Cache.fifo({Loader<K, V> loader, int maximumSize = 100}) {
    if (loader == null) {
      throw ArgumentError.notNull('loader');
    }
    if (maximumSize <= 0) {
      throw ArgumentError("Non-positive 'maximumSize' provided.");
    }
    return FifoCache<K, V>(loader, maximumSize);
  }

  /// Constructs a Least Recently Used (LRU) cache.
  ///
  /// The [loader] defines the function to construct items for the cache; and
  /// [maximumSize] defines the maximum number of items cached.
  factory Cache.lru({Loader<K, V> loader, int maximumSize = 100}) {
    if (loader == null) {
      throw ArgumentError.notNull('loader');
    }
    if (maximumSize <= 0) {
      throw ArgumentError("Non-positive 'maximumSize' provided.");
    }
    return LruCache<K, V>(loader, maximumSize);
  }

  /// Unnamed default constructor.
  Cache();

  /// Returns the value associated with the [key], otherwise `null`.
  Future<V> getIfPresent(K key);

  /// Returns the value associated with the [key].
  Future<V> get(K key);

  /// Stores the [value] associated with the [key].
  Future<V> set(K key, V value);

  /// Number of currently cached values.
  Future<int> size();

  /// Discards any cached value with the [key].
  Future<void> invalidate(K key);

  /// Discards all cached values.
  Future<void> invalidateAll();

  /// Returns the number of reaped items.
  Future<int> reap();
}
