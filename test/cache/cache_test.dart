import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:more/feature.dart';
import 'package:more/src/cache/empty.dart';
import 'package:more/src/cache/expiry.dart';
import 'package:more/src/cache/fifo.dart';
import 'package:more/src/cache/lru.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('cache', () {
    test('factories create expected types', () {
      check(Cache.empty(loader: immediateLoader))
          .isA<EmptyCache<int, String>>();
      check(
        Cache.expiry(
          loader: immediateLoader,
          updateExpiry: const Duration(seconds: 1),
        ),
      ).isA<ExpiryCache<int, String>>();
      check(Cache.fifo(loader: immediateLoader, maximumSize: 10))
          .isA<FifoCache<int, String>>();
      check(Cache.lru(loader: immediateLoader, maximumSize: 10))
          .isA<LruCache<int, String>>();
    });
    if (hasAssertionsEnabled) {
      test('expiry assertions', () {
        check(() => Cache<int, String>.expiry(loader: immediateLoader))
            .throws<AssertionError>();
        check(
          () => Cache<int, String>.expiry(
            loader: immediateLoader,
            updateExpiry: Duration.zero,
          ),
        ).throws<AssertionError>();
        check(
          () => Cache<int, String>.expiry(
            loader: immediateLoader,
            accessExpiry: const Duration(seconds: -1),
          ),
        ).throws<AssertionError>();
      });
      test('lru / fifo assertions', () {
        check(
          () => Cache<int, String>.lru(loader: immediateLoader, maximumSize: 0),
        ).throws<AssertionError>();
        check(
          () =>
              Cache<int, String>.fifo(loader: immediateLoader, maximumSize: -1),
        ).throws<AssertionError>();
      });
    }
  });
}
