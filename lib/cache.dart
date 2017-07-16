library more.collection.cache;

import 'dart:async';
import 'dart:math';

import 'package:more/src/cache/empty.dart';
import 'package:more/src/cache/expiry.dart';
import 'package:more/src/cache/fifo.dart';
import 'package:more/src/cache/loader.dart';
import 'package:more/src/cache/lru.dart';

export 'package:more/src/cache/loader.dart';

abstract class Cache<K, V> {

  /// Constructs an empty cache, useful mostly for testing.
  ///
  /// The [loader] defines the function to construct items for the cache.
  factory Cache.empty({Loader<K, V> loader}) => new EmptyCache(loader);

  /// Constructs an expiry cache.
  ///
  /// The [loader] defines the function to construct items for the cache.
  ///
  /// [accessExpiry] is the duration since the last access (or read) after which a cached item is
  /// eligible for eviction. Similarly [updateExpiry] is the duration since the last update (or
  /// write) after which a cached item is eligible for eviction. If either of the conditions
  /// match, the item is evicted. One of the conditions can be left `null` if you do not care.
  ///
  /// [evictionInterval] is the duration between eviction runs, leave `null` to automatically
  /// compute a sensible value.
  ///
  /// Note that items do not expire, if you don't interact with the cache. Eviction only happens
  /// when the [evictionInterval] exceeded and you modify or query the cache state.
  factory Cache.expiry(
      {Loader<K, V> loader,
      Duration accessExpiry,
      Duration updateExpiry,
      Duration evictionInterval}) {
    if (loader == null) {
      throw new ArgumentError.notNull('loader');
    }
    if (accessExpiry == null && updateExpiry == null) {
      throw new ArgumentError("Either 'accessExpiry' or 'updateExpiry' must be provided.");
    }
    if (evictionInterval == null) {
      if (accessExpiry != null && updateExpiry != null) {
        var milliseconds = min(accessExpiry.inMilliseconds, updateExpiry.inMilliseconds);
        evictionInterval = new Duration(milliseconds: milliseconds ~/ 10);
      } else if (accessExpiry != null) {
        evictionInterval = new Duration(milliseconds: accessExpiry.inMilliseconds ~/ 10);
      } else if (updateExpiry != null) {
        evictionInterval = new Duration(milliseconds: updateExpiry.inMilliseconds ~/ 10);
      }
    }
    return new ExpiryCache(loader, accessExpiry, updateExpiry, evictionInterval);
  }

  /// Constructs a First-in/First-out (FIFO) cache.
  ///
  /// The [loader] defines the function to construct items for the cache; and [maximumSize] defines
  /// the maximum number of items cached.
  factory Cache.fifo({Loader<K, V> loader, int maximumSize: 100}) {
    if (loader == null) {
      throw new ArgumentError.notNull('loader');
    }
    if (maximumSize < 0) {
      throw new RangeError.value(maximumSize, 'maximumSize');
    }
    return new FifoCache(loader, maximumSize);
  }

  /// Constructs a Least Recently Used (LRU) cache.
  ///
  /// The [loader] defines the function to construct items for the cache; and [maximumSize] defines
  /// the maximum number of items cached.
  factory Cache.lru({Loader<K, V> loader, int maximumSize: 100}) {
    if (loader == null) {
      throw new ArgumentError.notNull('loader');
    }
    if (maximumSize < 0) {
      throw new RangeError.value(maximumSize, 'maximumSize');
    }
    return new LruCache(loader, maximumSize);
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
  Future invalidate(K key);

  /// Discards all cached values.
  Future invalidateAll();
}
