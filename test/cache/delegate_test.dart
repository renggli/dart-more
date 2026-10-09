import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('delegate', () {
    Cache<int, String> newCache(Loader<int, String> loader) =>
        DelegateCache(Cache.lru(loader: loader, maximumSize: 5));
    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
  });
}
