import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('lru', () {
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
  });
}
