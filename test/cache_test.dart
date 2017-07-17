library more.test.cache_test;

import 'dart:async';

import 'package:more/cache.dart';
import 'package:test/test.dart';

// Loaders for testing
String failingLoader(int key) {
  fail('Loader should not be called');
  return null;
}

// Various common loaders used with the tests.
String immediateLoader(int key) => '$key';
Future<String> futureLoader(int key) => new Future.value(immediateLoader(key));
Future<String> delayedLoader(int key) =>
    new Future.delayed(const Duration(milliseconds: 10), () => immediateLoader(key));

// Basic tests that should pass on any (stateless) cache.
void statelessCacheTests(Cache<int, String> newCache(Loader<int, String> loader)) {
  test('empty', () {
    return newCache(failingLoader)
        .size()
        .then((value) => expect(value, 0, reason: 'cache should be empty'));
  });
  test('no present value', () {
    return newCache(failingLoader)
        .getIfPresent(1)
        .then((value) => expect(value, isNull, reason: 'there should be no present value'));
  });
  test('load immediate value', () {
    return newCache(immediateLoader)
        .get(1)
        .then((value) => expect(value, '1', reason: 'get value should be loaded'));
  });
  test('load future value', () {
    return newCache(futureLoader)
        .get(1)
        .then((value) => expect(value, '1', reason: 'get value should be loaded'));
  });
  test('load delayed value', () {
    return newCache(delayedLoader)
        .get(1)
        .then((value) => expect(value, '1', reason: 'get value should be loaded'));
  });
  test('set returns value', () {
    return newCache(failingLoader)
        .set(1, 'foo')
        .then((value) => expect(value, 'foo', reason: 'set value should be returned'));
  });
  test('invalidate empty', () {
    var cache = newCache(failingLoader);
    return cache
        .invalidate(1)
        .then((_) => cache.size())
        .then((value) => expect(value, 0, reason: 'cache should be empty'));
  });
  test('invalidate all empty', () {
    var cache = newCache(failingLoader);
    return cache
        .invalidateAll()
        .then((_) => cache.size())
        .then((value) => expect(value, 0, reason: 'cache should be empty'));
  });
}

void expiryCacheTest(Cache<int, String> newCache(Loader<int, String> loader), String name,
    List<int> load, List<int> present) {
  var absent = new Set()
    ..addAll(load)
    ..removeAll(present);

  test('$name', () async {
    var cache = newCache(immediateLoader);
    load.forEach((key) => cache.get(key));
    present.forEach((key) async =>
        expect(await cache.getIfPresent(key), '$key', reason: '$key should be present'));
    absent.forEach((key) async =>
        expect(await cache.getIfPresent(key), isNull, reason: '$key should be absent'));
  });
}

// Basic tests that should pass on any persistent cache (as long as no expiry kicks in).
void persistentCacheTests(Cache<int, String> newCache(Loader<int, String> loader)) {
  test('set and get', () {
    var cache = newCache(failingLoader);
    return cache
        .set(1, 'foo')
        .then((value) => expect(value, 'foo', reason: 'return value'))
        .then((_) => cache.get(1))
        .then((value) => expect(value, 'foo', reason: 'get value'));
  });
  test('set and size', () {
    var cache = newCache(failingLoader);
    return cache
        .set(1, 'foo')
        .then((_) => cache.size())
        .then((value) => expect(value, 1, reason: 'there should be one item'));
  });
  test('set, invalidate, get', () {
    var cache = newCache(failingLoader);
    return cache
        .set(1, 'foo')
        .then((_) => cache.invalidate(1))
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, isNull, reason: 'key was invalidated'));
  });
  test('set, invalidate all, get', () {
    var cache = newCache(failingLoader);
    return cache
        .set(1, 'foo')
        .then((_) => cache.invalidateAll())
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, isNull, reason: 'cache was invalidated'));
  });
  test('get with immediate value is persistent', () {
    var cache = newCache(immediateLoader);
    return cache
        .get(1)
        .then((value) => expect(value, '1'))
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, '1', reason: 'loaded value is persistent'));
  });
  test('get with future value is persistent', () {
    var cache = newCache(futureLoader);
    return cache
        .get(1)
        .then((value) => expect(value, '1'))
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, '1', reason: 'loaded value is persistent'));
  });
  test('get with delayed value is persistent', () {
    var cache = newCache(delayedLoader);
    return cache
        .get(1)
        .then((value) => expect(value, '1'))
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, '1', reason: 'loaded value is persistent'));
  });
  test('get with invalidated key is not persistent', () {
    var cache = newCache(delayedLoader);
    var loaded1 = cache.get(1);
    var loaded2 = cache.get(2);
    return cache
        .invalidate(2)
        .then((_) => Future.wait([loaded1, loaded2]))
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, '1', reason: 'value 1 should still be present'))
        .then((_) => cache.getIfPresent(2))
        .then((value) => expect(value, isNull, reason: 'value 2 should still be absent'));
  });

  test('get with invalidated cache is not persistent', () {
    var cache = newCache(delayedLoader);
    var loaded = cache.get(1);
    return cache
        .invalidateAll()
        .then((_) => loaded)
        .then((_) => cache.getIfPresent(1))
        .then((value) => expect(value, isNull, reason: 'cache was invalidated'));
  });
}

void main() {
  group('empty', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return new Cache.empty(loader: loader);
    }

    statelessCacheTests(newCache);
  });
  group('expiry', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return new Cache.expiry(loader: loader, accessExpiry: new Duration(hours: 1));
    }

    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
  });
  group('lru', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return new Cache.lru(loader: loader, maximumSize: 5);
    }

    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
    expiryCacheTest(newCache, 'linear expiry', [0, 1, 2, 3, 4, 5, 6], [2, 3, 4, 5, 6]);
    expiryCacheTest(newCache, 'reused expiry', [0, 1, 2, 3, 4, 0, 1, 5], [0, 1, 3, 4, 5]);
  });
  group('fifo', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return new Cache.fifo(loader: loader, maximumSize: 5);
    }

    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
    expiryCacheTest(newCache, 'linear expiry', [0, 1, 2, 3, 4, 5, 6], [2, 3, 4, 5, 6]);
    expiryCacheTest(newCache, 'reused expiry', [0, 1, 2, 3, 4, 0, 1, 5], [1, 2, 3, 4, 5]);
  });
}
