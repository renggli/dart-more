import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('fifo', () {
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
  });
}
