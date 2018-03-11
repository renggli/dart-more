library more.cache.delegate;

import 'dart:async' show Future;

import 'package:more/cache.dart';

/// A cache that delegates to another one.
class DelegateCache<K, V> extends Cache<K, V> {
  final Cache<K, V> delegate;

  DelegateCache(this.delegate);

  @override
  Future<V> getIfPresent(K key) => delegate.getIfPresent(key);

  @override
  Future<V> get(K key) => delegate.get(key);

  @override
  Future<V> set(K key, V value) => delegate.set(key, value);

  @override
  Future<int> size() => delegate.size();

  @override
  Future invalidate(K key) => delegate.invalidate(key);

  @override
  Future invalidateAll() => delegate.invalidateAll();

  @override
  Future<int> reap() => delegate.reap();
}
