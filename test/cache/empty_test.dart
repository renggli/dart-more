import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('empty', () {
    Cache<int, String> newCache(Loader<int, String> loader) =>
        Cache.empty(loader: loader);
    statelessCacheTests(newCache);
  });
}
