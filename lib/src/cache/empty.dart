library more.cache.empty;

import 'dart:async' show Future, FutureOr;

import 'package:more/cache.dart';

/// An empty or null cache, useful mostly for testing.
class EmptyCache<K, V> extends Cache<K, V> {
  final Loader<K, FutureOr<V>> loader;

  EmptyCache(this.loader);

  @override
  Future<V> getIfPresent(K key) async => null;

  @override
  Future<V> get(K key) async => loader(key);

  @override
  Future<V> set(K key, V value) async => value;

  @override
  Future<int> size() async => 0;

  @override
  Future invalidate(K key) async => null;

  @override
  Future invalidateAll() async => null;

  @override
  Future<int> reap() async => 0;
}
