library more.test.cache_test;

import 'dart:async';

import 'package:more/cache.dart';
import 'package:test/test.dart';

Future verifyKeys<K, V>(Cache<K, V> cache, int size, Iterable<K> presentKeys,
    Iterable<K> absentKeys) async {
  expect(await cache.size(), size);
  for (var key in presentKeys) {
    var value = await cache.getIfPresent(key);
    expect(value, isNotNull, reason: 'Expected $key to be present.');
  }
  for (var key in absentKeys) {
    var value = await cache.getIfPresent(key);
    expect(value, isNull, reason: 'Expected $key to be absent, but got $value.');
  }
}

// Loaders for testing
String immediateLoader(int key) => '$key';

Future<String> futureLoader(int key) => new Future.value(immediateLoader(key));

const shortDelay = const Duration(milliseconds: 5);
const longDelay = const Duration(milliseconds: 15);
Future<String> delayedLoader(int key) => new Future.delayed(shortDelay, () => immediateLoader(key));

void main() {
  group('lru', () {
    testWith(Loader<int, String> loader) {
      return () async {
        var cache = new Cache.lru(loader: loader, maxSize: 2);
        expect(await cache.get(1), '1');
        expect(await cache.get(2), '2');
        expect(await cache.get(3), '3');
        await verifyKeys(cache, 2, [2, 3], [1]);
        expect(await cache.get(2), '2');
        expect(await cache.get(4), '4');
        await verifyKeys(cache, 2, [2, 4], [1, 3]);
      };
    }
    test('immediate loader', testWith(immediateLoader));
    test('future loader', testWith(futureLoader));
    test('delayed loader', testWith(delayedLoader));
  });
  group('fifo', () {
    testWith(Loader<int, String> loader) {
      return () async {
        var cache = new Cache.fifo(loader: loader, maxSize: 2);
        expect(await cache.get(1), '1');
        expect(await cache.get(2), '2');
        expect(await cache.get(3), '3');
        await verifyKeys(cache, 2, [2, 3], [1]);
        expect(await cache.get(2), '2');
        expect(await cache.get(4), '4');
        await verifyKeys(cache, 2, [3, 4], [1, 2]);
      };
    }
    test('immediate loader', testWith(immediateLoader));
    test('future loader', testWith(futureLoader));
    test('delayed loader', testWith(delayedLoader));
  });
  group('expiry', () {
    testWith(Loader<int, String> loader) {
      return () async {
        var cache = new Cache.expiry(loader: loader, accessExpiry: new Duration(hours: 1));
        expect(await cache.get(1), '1');
        expect(await cache.get(2), '2');
        expect(await cache.get(3), '3');
        await verifyKeys(cache, 3, [1, 2, 3], []);
        expect(await cache.get(2), '2');
        expect(await cache.get(4), '4');
        await verifyKeys(cache, 4, [1, 2, 3, 4], []);
      };
    }
    test('immediate loader', testWith(immediateLoader));
    test('future loader', testWith(futureLoader));
    test('delayed loader', testWith(delayedLoader));
  });
  group('empty', () {
    testWith(Loader<int, String> loader) {
      return () async {
        var cache = new Cache.empty(loader: loader);
        expect(await cache.get(1), '1');
        expect(await cache.get(2), '2');
        expect(await cache.get(3), '3');
        expect(await cache.size(), 0);
        await verifyKeys(cache, 0, [], [1, 2, 3]);
        expect(await cache.get(2), '2');
        expect(await cache.get(4), '4');
        expect(await cache.size(), 0);
        await verifyKeys(cache, 0, [], [1, 2, 3, 4]);
      };
    }
    test('immediate loader', testWith(immediateLoader));
    test('future loader', testWith(futureLoader));
    test('delayed loader', testWith(delayedLoader));
  });
}
