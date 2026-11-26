import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  Cache<int, String> newCache(Loader<int, String> loader) =>
      Cache.fifo(loader: loader, maximumSize: 5);
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
    [1, 2, 3, 4, 5],
  );
  test('set preserves insertion order', () async {
    final cache = Cache.fifo(loader: immediateLoader, maximumSize: 2);
    await cache.set(1, 'a');
    await cache.set(2, 'b');
    await cache.set(1, 'aa');
    await cache.set(3, 'c');
    check(await cache.getIfPresent(1)).isNull;
    check(await cache.getIfPresent(2)).equals('b');
    check(await cache.getIfPresent(3)).equals('c');
  });
}
