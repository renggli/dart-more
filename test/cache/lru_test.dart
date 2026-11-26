import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  Cache<int, String> newCache(Loader<int, String> loader) =>
      Cache.lru(loader: loader, maximumSize: 5);
  statelessCacheTests(newCache);
  persistentCacheTests(newCache);
  cacheEvictionTest(
    newCache,
    'linear expiry',
    [0, 1, 2, 3, 4, 5, 6],
    [2, 3, 4, 5, 6],
  );
  cacheEvictionTest(
    newCache,
    'reused expiry',
    [0, 1, 2, 3, 4, 0, 1, 5],
    [0, 1, 3, 4, 5],
  );
  test('invalid maximumSize', () {
    check(() => Cache.lru(loader: immediateLoader, maximumSize: 0))
        .throws<RangeError>();
    check(() => Cache.lru(loader: immediateLoader, maximumSize: -1))
        .throws<RangeError>();
    check(
      () =>
          Cache.lru(loader: immediateLoader, maximumSize: -9223372036854775808),
    ).throws<RangeError>();
  });
  test('maximumSize = 1', () async {
    final cache = Cache.lru(loader: immediateLoader, maximumSize: 1);
    check(await cache.get(1)).equals('1');
    check(await cache.get(2)).equals('2');
    check(await cache.getIfPresent(1)).isNull;
    check(await cache.getIfPresent(2)).equals('2');
    check(await cache.size()).equals(1);
  });
  test('set promotes entry and keeps size bounded', () async {
    final cache = Cache.lru(loader: immediateLoader, maximumSize: 2);
    await cache.set(1, 'a');
    await cache.set(2, 'b');
    await cache.set(1, 'aa');
    await cache.set(3, 'c');
    check(await cache.getIfPresent(1)).equals('aa');
    check(await cache.getIfPresent(2)).isNull;
    check(await cache.getIfPresent(3)).equals('c');
  });
  test('failed future is evicted on error', () async {
    var attempts = 0;
    final cache = Cache.lru(
      loader: (int key) async {
        attempts++;
        if (attempts == 1) throw StateError('load failure');
        return 'ok-$key';
      },
      maximumSize: 5,
    );
    await check(cache.get(1)).throws<StateError>();
    check(await cache.size()).equals(0);
    check(await cache.get(1)).equals('ok-1');
    check(await cache.size()).equals(1);
  });
  test('failed future in set does not poison cache', () async {
    final cache = newCache(immediateLoader);
    await check(cache.set(1, Future.error(StateError('set failure'))))
        .throws<StateError>();
    check(await cache.size()).equals(0);
    check(await cache.getIfPresent(1)).isNull;
    check(await cache.get(1)).equals('1');
  });
  test('failing get does not evict newer set entry', () async {
    final loadCompleter = Completer<String>();
    final cache = Cache.lru(
      loader: (int key) => loadCompleter.future,
      maximumSize: 5,
    );
    final pendingGet = cache.get(1);
    await cache.set(1, 'good');
    loadCompleter.completeError(StateError('slow load failed'));
    await check(pendingGet).throws<StateError>();
    check(await cache.getIfPresent(1)).equals('good');
    check(await cache.size()).equals(1);
  });
}
