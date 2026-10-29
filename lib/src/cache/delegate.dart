import 'dart:async' show Future, FutureOr;

import '../printer/object/object.dart';
import 'cache.dart';

/// A cache that delegates to another one.
class DelegateCache<K, V> extends Cache<K, V> {
  /// Creates a cache that delegates to [delegate].
  const new(this.delegate);

  /// The underlying cache being delegated to.
  final Cache<K, V> delegate;

  @override
  Future<V?> getIfPresent(K key) => delegate.getIfPresent(key);

  @override
  Future<V> get(K key) => delegate.get(key);

  @override
  Future<Map<K, V>> getAll(Iterable<K> keys) => delegate.getAll(keys);

  @override
  Future<V> set(K key, FutureOr<V> value) => delegate.set(key, value);

  @override
  Future<void> setAll(Map<K, FutureOr<V>> values) => delegate.setAll(values);

  @override
  Future<void> putAll(Map<K, FutureOr<V>> values) => delegate.putAll(values);

  @override
  Future<int> size() => delegate.size();

  @override
  Future<void> invalidate(K key) => delegate.invalidate(key);

  @override
  Future<void> invalidateAll([Iterable<K>? keys]) =>
      delegate.invalidateAll(keys);

  @override
  Future<int> reap() => delegate.reap();

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(delegate, name: 'delegate');
}
