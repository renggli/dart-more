library more.test.cache_test;

import 'dart:async';

import 'package:more/cache.dart';
import 'package:test/test.dart';

const Duration delay = Duration(milliseconds: 10);

// Various common loaders used with the tests.
String failingLoader(int key) => fail('Loader should never be called');
String immediateLoader(int key) => '$key';
Future<String> futureLoader(int key) => Future.value(immediateLoader(key));
Future<String> delayedLoader(int key) =>
    Future.delayed(delay, () => immediateLoader(key));
String throwingLoader(int key) => throw UnsupportedError('$key');

// Basic tests that should pass on any (stateless) cache.
void statelessCacheTests(
    Cache<int, String> newCache(Loader<int, String> loader)) {
  test('empty', () {
    return newCache(failingLoader)
        .size()
        .then((value) => expect(value, 0, reason: 'cache should be empty'));
  });
  test('no present value', () {
    return newCache(failingLoader).getIfPresent(1).then((value) =>
        expect(value, isNull, reason: 'there should be no present value'));
  });
  test('load immediate value', () {
    return newCache(immediateLoader).get(1).then(
        (value) => expect(value, '1', reason: 'get value should be loaded'));
  });
  test('load future value', () {
    return newCache(futureLoader).get(1).then(
        (value) => expect(value, '1', reason: 'get value should be loaded'));
  });
  test('load throwing value', () {
    return newCache(throwingLoader).get(1).then(
        (value) => fail('expected error'),
        onError: (exception) => expect(exception, isUnsupportedError));
  });
  test('load delayed value', () {
    return newCache(delayedLoader).get(1).then(
        (value) => expect(value, '1', reason: 'get value should be loaded'));
  });
  test('set returns value', () {
    return newCache(failingLoader).set(1, 'foo').then((value) =>
        expect(value, 'foo', reason: 'set value should be returned'));
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
  test('reap is a no-op', () {
    return newCache(failingLoader)
        .reap()
        .then((size) => expect(size, 0, reason: 'nothing should be gone'));
  });
}

void cacheEvictionTest(Cache<int, String> newCache(Loader<int, String> loader),
    String name, List<int> load, List<int> present) {
  var absent = Set<int>()
    ..addAll(load)
    ..removeAll(present);

  test('$name', () async {
    var cache = newCache(immediateLoader);
    for (var key in load) {
      expect(await cache.get(key), '$key');
    }
    for (var key in present) {
      expect(await cache.getIfPresent(key), '$key',
          reason: '$key should be present');
    }
    for (var key in absent) {
      expect(await cache.getIfPresent(key), isNull,
          reason: '$key should be absent');
    }
  });
}

// Basic tests that should pass on any persistent cache (as long as no expiry kicks in).
void persistentCacheTests(
    Cache<int, String> newCache(Loader<int, String> loader)) {
  test('get and set', () {
    var cache = newCache(immediateLoader);
    return cache
        .get(1)
        .then((_) => cache.set(1, 'foo'))
        .then((value) => expect(value, 'foo', reason: 'update loaded value'))
        .then((_) => cache.get(1))
        .then((value) => expect(value, 'foo', reason: 'updated value'));
  });
  test('load throwing value has no side-effect', () {
    var cache = newCache(throwingLoader);
    return cache
        .get(1)
        .catchError((exception) => '1')
        .then((_) => cache.getIfPresent(1))
        .then(
            (value) => expect(value, isNull, reason: 'loader threw exception'));
  });
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
        .then(
            (value) => expect(value, isNull, reason: 'cache was invalidated'));
  });
  test('get with immediate value is persistent', () {
    var cache = newCache(immediateLoader);
    return cache
        .get(1)
        .then((value) => expect(value, '1'))
        .then((_) => cache.getIfPresent(1))
        .then((value) =>
            expect(value, '1', reason: 'loaded value is persistent'));
  });
  test('get with future value is persistent', () {
    var cache = newCache(futureLoader);
    return cache
        .get(1)
        .then((value) => expect(value, '1'))
        .then((_) => cache.getIfPresent(1))
        .then((value) =>
            expect(value, '1', reason: 'loaded value is persistent'));
  });
  test('get with delayed value is persistent', () {
    var cache = newCache(delayedLoader);
    return cache
        .get(1)
        .then((value) => expect(value, '1'))
        .then((_) => cache.getIfPresent(1))
        .then((value) =>
            expect(value, '1', reason: 'loaded value is persistent'));
  });
  test('get with invalidated key is not persistent', () {
    var cache = newCache(delayedLoader);
    var loaded1 = cache.get(1);
    var loaded2 = cache.get(2);
    return cache
        .invalidate(2)
        .then((_) => Future.wait([loaded1, loaded2]))
        .then((_) => cache.getIfPresent(1))
        .then((value) =>
            expect(value, '1', reason: 'value 1 should still be present'))
        .then((_) => cache.getIfPresent(2))
        .then((value) =>
            expect(value, isNull, reason: 'value 2 should still be absent'));
  });
  test('get with invalidated cache is not persistent', () {
    var cache = newCache(delayedLoader);
    var loaded = cache.get(1);
    return cache
        .invalidateAll()
        .then((_) => loaded)
        .then((_) => cache.getIfPresent(1))
        .then(
            (value) => expect(value, isNull, reason: 'cache was invalidated'));
  });
  test('reap is invariant', () {
    var cache = newCache(failingLoader);
    return cache
        .set(1, 'foo')
        .then((_) => cache.reap())
        .then((value) => expect(value, 0, reason: 'nothing should be gone'))
        .then((_) => cache.size())
        .then((value) => expect(value, 1, reason: 'one item should be left'));
  });
}

void main() {
  group('clock', () {
    test('system clock', () {
      expect(systemClock().difference(DateTime.now()).inSeconds, 0);
    });
  });
  group('empty', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return Cache.empty(loader: loader);
    }

    statelessCacheTests(newCache);
    test('missing loader', () {
      expect(() => Cache.empty(), throwsArgumentError);
    });
  });
  group('delegate', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return DelegateCache(Cache.lru(loader: loader, maximumSize: 5));
    }

    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
  });
  group('expiry', () {
    Duration offset;
    DateTime offsetClock() => DateTime(2000).add(offset);
    setUp(() => offset = Duration.zero);

    Cache<int, String> newUpdateExpireCache(Loader<int, String> loader) {
      return Cache.expiry(
          loader: loader,
          clock: offsetClock,
          updateExpiry: const Duration(seconds: 20));
    }

    Cache<int, String> newAccessExpireCache(Loader<int, String> loader) {
      return Cache.expiry(
          loader: loader,
          clock: offsetClock,
          accessExpiry: const Duration(seconds: 20));
    }

    statelessCacheTests(newUpdateExpireCache);
    persistentCacheTests(newUpdateExpireCache);

    group('constructors', () {
      test('missing loader', () {
        expect(() => Cache.expiry(accessExpiry: const Duration(seconds: 20)),
            throwsArgumentError);
      });
      test('missing expiry', () {
        expect(
            () => Cache.expiry(loader: immediateLoader), throwsArgumentError);
      });
      test('negative access expiry', () {
        expect(
            () => Cache.expiry(
                loader: immediateLoader, accessExpiry: Duration.zero),
            throwsArgumentError);
      });
      test('negative update expiry', () {
        expect(
            () => Cache.expiry(
                loader: immediateLoader, updateExpiry: Duration.zero),
            throwsArgumentError);
      });
    });

    group('update expire cache', () {
      test('expire a set value after it has been updated', () {
        var cache = newUpdateExpireCache(immediateLoader);
        return cache
            .set(1, '2')
            .then((_) => offset = const Duration(seconds: 20))
            .then((_) => cache.getIfPresent(1))
            .then((value) => expect(value, '2', reason: 'value is set'))
            .then((_) => cache.set(1, '3'))
            .then((_) => offset = const Duration(seconds: 40))
            .then((_) => cache.getIfPresent(1))
            .then((value) => expect(value, '3', reason: 'value is updated'))
            .then((_) => offset = const Duration(seconds: 41))
            .then((_) => cache.getIfPresent(1))
            .then(
                (value) => expect(value, isNull, reason: 'value has expried'));
      });
      test('loaded value expires', () {
        var cache = newUpdateExpireCache(immediateLoader);
        return cache
            .get(1)
            .then((value) => expect(value, '1', reason: 'value is loaded'))
            .then((_) => offset = const Duration(seconds: 20))
            .then((_) => cache.getIfPresent(1))
            .then(
                (value) => expect(value, '1', reason: 'value is still present'))
            .then((_) => offset = const Duration(seconds: 21))
            .then((_) => cache.getIfPresent(1))
            .then((value) => expect(value, isNull, reason: 'value has expried'))
            .then((_) => cache.size())
            .then((size) => expect(size, 0, reason: 'cache should be empty'));
      });
      test('re-loaded value expires', () {
        var counter = 0;
        var cache = newUpdateExpireCache((key) {
          counter++;
          return immediateLoader(key);
        });
        return cache
            .get(0)
            .then((value) => expect(value, '0', reason: 'value is loaded'))
            .then((value) => expect(counter, 1, reason: 'loaded once'))
            .then((_) => offset = const Duration(seconds: 20))
            .then((_) => cache.get(0))
            .then(
                (value) => expect(value, '0', reason: 'value is still present'))
            .then((value) => expect(counter, 1, reason: 'still loaded once'))
            .then((_) => offset = const Duration(seconds: 21))
            .then((_) => cache.get(0))
            .then((value) => expect(value, '0', reason: 'value is reloaded'))
            .then((value) => expect(counter, 2, reason: 'value loaded again'));
      });
      test('reap expired items', () {
        var cache = newUpdateExpireCache(immediateLoader);
        return cache
            .set(1, '1')
            .then((_) => offset = const Duration(seconds: 21))
            .then((_) => cache.size())
            .then(
                (size) => expect(size, 1, reason: 'cache has not been reaped'))
            .then((_) => cache.reap())
            .then((size) => expect(size, 1, reason: 'one item should be gone'))
            .then((_) => cache.size())
            .then((size) => expect(size, 0, reason: 'cache should be empty'));
      });
    });
    group('access expire cache', () {
      test('expire a set value after it has been updated', () {
        var cache = newAccessExpireCache(immediateLoader);
        return cache
            .set(1, '2')
            .then((_) => offset = const Duration(seconds: 20))
            .then((_) => cache.getIfPresent(1))
            .then((value) => expect(value, '2', reason: 'value is set'))
            .then((_) => cache.set(1, '3'))
            .then((_) => offset = const Duration(seconds: 40))
            .then((_) => cache.getIfPresent(1))
            .then((value) => expect(value, '3', reason: 'value is updated'))
            .then((_) => offset = const Duration(seconds: 61))
            .then((_) => cache.getIfPresent(1))
            .then(
                (value) => expect(value, isNull, reason: 'value has expried'));
      });
      test('loaded value expires', () {
        var cache = newAccessExpireCache(immediateLoader);
        return cache
            .get(1)
            .then((value) => expect(value, '1', reason: 'value is loaded'))
            .then((_) => offset = const Duration(seconds: 20))
            .then((_) => cache.getIfPresent(1))
            .then(
                (value) => expect(value, '1', reason: 'value is still present'))
            .then((_) => offset = const Duration(seconds: 41))
            .then((_) => cache.getIfPresent(1))
            .then((value) => expect(value, isNull, reason: 'value has expried'))
            .then((_) => cache.size())
            .then((size) => expect(size, 0, reason: 'cache should be empty'));
      });
      test('re-loaded value expires', () {
        var counter = 0;
        var cache = newAccessExpireCache((key) {
          counter++;
          return immediateLoader(key);
        });
        return cache
            .get(0)
            .then((value) => expect(value, '0', reason: 'value is loaded'))
            .then((value) => expect(counter, 1, reason: 'loaded once'))
            .then((_) => offset = const Duration(seconds: 20))
            .then((_) => cache.get(0))
            .then(
                (value) => expect(value, '0', reason: 'value is still present'))
            .then((value) => expect(counter, 1, reason: 'still loaded once'))
            .then((_) => offset = const Duration(seconds: 41))
            .then((_) => cache.get(0))
            .then((value) => expect(value, '0', reason: 'value is reloaded'))
            .then((value) => expect(counter, 2, reason: 'value loaded again'));
      });
      test('reap expired items', () {
        var cache = newAccessExpireCache(immediateLoader);
        return cache
            .set(1, '1')
            .then((_) => offset = const Duration(seconds: 120))
            .then((_) => cache.size())
            .then(
                (size) => expect(size, 1, reason: 'cache has not been reaped'))
            .then((_) => cache.reap())
            .then((size) => expect(size, 1, reason: 'one item should be gone'))
            .then((_) => cache.size())
            .then((size) => expect(size, 0, reason: 'cache should be empty'));
      });
    });
  });
  group('lru', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return Cache.lru(loader: loader, maximumSize: 5);
    }

    group('constructors', () {
      test('missing lru', () {
        expect(() => Cache.lru(), throwsArgumentError);
      });
      test('non positive max size', () {
        expect(() => Cache.lru(loader: immediateLoader, maximumSize: 0),
            throwsArgumentError);
      });
    });

    statelessCacheTests(newCache);
    persistentCacheTests(newCache);

    cacheEvictionTest(
        newCache, 'linear expiry', [0, 1, 2, 3, 4, 5, 6], [2, 3, 4, 5, 6]);
    cacheEvictionTest(
        newCache, 'reused expiry', [0, 1, 2, 3, 4, 0, 1, 5], [0, 1, 3, 4, 5]);
  });
  group('fifo', () {
    Cache<int, String> newCache(Loader<int, String> loader) {
      return Cache.fifo(loader: loader, maximumSize: 5);
    }

    group('constructors', () {
      test('missing loader', () {
        expect(() => Cache.fifo(), throwsArgumentError);
      });
      test('non positive max size', () {
        expect(() => Cache.fifo(loader: immediateLoader, maximumSize: 0),
            throwsArgumentError);
      });
    });

    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
    cacheEvictionTest(
        newCache, 'linear expiry', [0, 1, 2, 3, 4, 5, 6], [2, 3, 4, 5, 6]);
    cacheEvictionTest(
        newCache, 'reused expiry', [0, 1, 2, 3, 4, 0, 1, 5], [1, 2, 3, 4, 5]);
  });
}
