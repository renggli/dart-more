import 'dart:async' show Future, FutureOr;

import '../../cache.dart';

/// A cache that delegates to another one.
class DelegateCache<K, V> extends Cache<K, V> {
  final Cache<K, V> delegate;

  const DelegateCache(this.delegate);

  @override
  Future<V?> getIfPresent(K key) => delegate.getIfPresent(key);

  @override
  Future<V> get(K key) => delegate.get(key);

  @override
  Future<V> set(K key, FutureOr<V> value) => delegate.set(key, value);

  @override
  Future<int> size() => delegate.size();

  @override
  Future<void> invalidate(K key) => delegate.invalidate(key);

  @override
  Future<void> invalidateAll() => delegate.invalidateAll();

  @override
  Future<int> reap() => delegate.reap();
}
