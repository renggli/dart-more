import 'package:clock/clock.dart';
import 'package:more/cache.dart';
import 'package:test/test.dart';

const Duration delay = Duration(milliseconds: 10);

typedef NewCache<T, S> = Cache<T, S> Function(Loader<T, S> loader);

// Various common loaders used with the tests.
String immediateLoader(int key) => '$key';

String immediateFailingLoader(int key) =>
    throw StateError('Loader for $key is failing.');

Future<String> futureLoader(int key) => Future.value(immediateLoader(key));

Future<String> futureFailingLoader(int key) =>
    Future.error(StateError('Loader for $key is failing.'));

Future<String> futureDelayedLoader(int key) =>
    Future.delayed(delay, () => immediateLoader(key));

// Basic tests that should pass on any (stateless) cache.
void statelessCacheTests(NewCache<int, String> newCache) {
  test('empty', () async {
    final cache = newCache(immediateFailingLoader);
    await expectLater(cache.size(), completion(0));
  });
  test('no present value', () async {
    final cache = newCache(immediateFailingLoader);
    await expectLater(cache.getIfPresent(1), completion(isNull));
  });
  test('set present value', () async {
    final cache = newCache(immediateLoader);
    await expectLater(cache.set(1, '2'), completion('2'));
  });
  test('load immediate value', () async {
    final cache = newCache(immediateLoader);
    await expectLater(cache.get(1), completion('1'));
  });
  test('load immediate failing value', () async {
    final cache = newCache(immediateFailingLoader);
    await expectLater(cache.get(1), throwsA(isStateError));
  });
  test('load future value', () async {
    final cache = newCache(futureLoader);
    await expectLater(cache.get(1), completion('1'));
  });
  test('load future failing value', () async {
    final cache = newCache(futureFailingLoader);
    await expectLater(cache.get(1), throwsA(isStateError));
  });
  test('load future delayed value', () async {
    final cache = newCache(futureDelayedLoader);
    await expectLater(cache.get(1), completion('1'));
  });
  test('invalidate empty', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.invalidate(1);
    await expectLater(cache.size(), completion(0));
  });
  test('invalidate all empty', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.invalidateAll();
    await expectLater(cache.size(), completion(0));
  });
  test('reap is a no-op', () async {
    final cache = newCache(immediateFailingLoader);
    await expectLater(cache.reap(), completion(0));
  });
}

void cacheEvictionTest(NewCache<int, String> newCache, String name,
    List<int> load, List<int> present) {
  final absent = <int>{}
    ..addAll(load)
    ..removeAll(present);

  test(name, () async {
    final cache = newCache(immediateLoader);
    for (final key in load) {
      await expectLater(cache.get(key), completion('$key'));
    }
    for (final key in present) {
      await expectLater(cache.getIfPresent(key), completion('$key'));
    }
    for (final key in absent) {
      await expectLater(cache.getIfPresent(key), completion(isNull));
    }
  });
}

// Basic tests that should pass on any persistent cache
// (as long as no expiry kicks in).
void persistentCacheTests(NewCache<int, String> newCache) {
  test('get and set', () async {
    final cache = newCache(immediateLoader);
    await expectLater(cache.get(1), completion('1'));
    await expectLater(cache.set(1, 'foo'), completion('foo'));
    await expectLater(cache.getIfPresent(1), completion('foo'));
  });
  test('load throwing value has no side-effect', () async {
    final cache = newCache(immediateFailingLoader);
    await expectLater(cache.get(1), throwsA(isStateError));
    await expectLater(cache.getIfPresent(1), completion(isNull));
  });
  test('set and get', () async {
    final cache = newCache(immediateFailingLoader);
    await expectLater(cache.set(1, 'foo'), completion('foo'));
    await expectLater(cache.get(1), completion('foo'));
  });
  test('set and size', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    await expectLater(cache.size(), completion(1));
  });
  test('set, invalidate, get', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    await cache.invalidate(1);
    await expectLater(cache.getIfPresent(1), completion(isNull));
  });
  test('set, invalidate all, get', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    await cache.invalidateAll();
    await expectLater(cache.getIfPresent(1), completion(isNull));
  });
  test('get with immediate value is persistent', () async {
    final cache = newCache(immediateLoader);
    await expectLater(cache.get(1), completion('1'));
    await expectLater(cache.getIfPresent(1), completion('1'));
  });
  test('get with future value is persistent', () async {
    final cache = newCache(futureLoader);
    await expectLater(cache.get(1), completion('1'));
    await expectLater(cache.getIfPresent(1), completion('1'));
  });
  test('get with delayed value is persistent', () async {
    final cache = newCache(futureDelayedLoader);
    await expectLater(cache.get(1), completion('1'));
    await expectLater(cache.getIfPresent(1), completion('1'));
  });
  test('get with invalidated key is not persistent', () async {
    final cache = newCache(futureDelayedLoader);
    final loaded1 = cache.get(1);
    final loaded2 = cache.get(2);
    await cache.invalidate(2);
    await loaded1;
    await loaded2;
    await expectLater(cache.getIfPresent(1), completion('1'));
    await expectLater(cache.getIfPresent(2), completion(isNull));
  });
  test('get with invalidated cache is not persistent', () async {
    final cache = newCache(futureDelayedLoader);
    final loaded = cache.get(1);
    await cache.invalidateAll();
    await loaded;
    await expectLater(cache.getIfPresent(1), completion(isNull));
  });
  test('reap is invariant', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    await expectLater(cache.reap(), completion(0));
    await expectLater(cache.size(), completion(1));
  });
}

void main() {
  group('empty', () {
    Cache<int, String> newCache(Loader<int, String> loader) =>
        Cache.empty(loader: loader);
    statelessCacheTests(newCache);
  });
  group('delegate', () {
    Cache<int, String> newCache(Loader<int, String> loader) =>
        DelegateCache(Cache.lru(loader: loader, maximumSize: 5));
    statelessCacheTests(newCache);
    persistentCacheTests(newCache);
  });
  group('expiry', () {
    var offset = Duration.zero;
    final current = DateTime.now();
    void clockTest(String name, Future Function() body) =>
        () => withClock(Clock(() => current.add(offset)), body);

    Cache<int, String> newUpdateExpireCache(Loader<int, String> loader) =>
        Cache.expiry(loader: loader, updateExpiry: const Duration(seconds: 20));

    Cache<int, String> newAccessExpireCache(Loader<int, String> loader) =>
        Cache.expiry(loader: loader, accessExpiry: const Duration(seconds: 20));

    statelessCacheTests(newUpdateExpireCache);
    persistentCacheTests(newUpdateExpireCache);

    group('constructors', () {
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
      clockTest('expire a set value after it has been updated', () async {
        final cache = newUpdateExpireCache(immediateLoader);
        await expectLater(cache.set(1, '2'), completion('2'));
        offset = const Duration(seconds: 20);
        await expectLater(cache.getIfPresent(1), completion('2'));
        await expectLater(cache.set(1, '3'), completion('3'));
        offset = const Duration(seconds: 40);
        await expectLater(cache.getIfPresent(1), completion('3'));
        offset = const Duration(seconds: 41);
        await expectLater(cache.getIfPresent(1), completion(isNull));
      });
      clockTest('loaded value expires', () async {
        final cache = newUpdateExpireCache(immediateLoader);
        await expectLater(cache.get(1), completion('1'));
        offset = const Duration(seconds: 20);
        await expectLater(cache.getIfPresent(1), completion('1'));
        offset = const Duration(seconds: 21);
        await expectLater(cache.getIfPresent(1), completion(isNull));
        await expectLater(cache.size(), completion(0));
      });
      clockTest('re-loaded value expires', () async {
        var counter = 0;
        final cache = newUpdateExpireCache((key) {
          counter++;
          return immediateLoader(key);
        });
        await expectLater(cache.get(0), completion('0'));
        expect(counter, 1);
        offset = const Duration(seconds: 20);
        await expectLater(cache.get(0), completion('0'));
        expect(counter, 1);
        offset = const Duration(seconds: 21);
        await expectLater(cache.get(0), completion('0'));
        expect(counter, 2);
      });
      clockTest('reap expired items', () async {
        final cache = newUpdateExpireCache(immediateLoader);
        await cache.set(1, 'foo');
        offset = const Duration(seconds: 21);
        await expectLater(cache.size(), completion(1));
        await expectLater(cache.reap(), completion(1));
        await expectLater(cache.size(), completion(0));
      });
    });
    group('access expire cache', () {
      clockTest('expire a set value after it has been updated', () async {
        final cache = newAccessExpireCache(immediateLoader);
        await cache.set(1, 'foo');
        offset = const Duration(seconds: 20);
        await expectLater(cache.getIfPresent(1), completion('foo'));
        await cache.set(1, 'bar');
        offset = const Duration(seconds: 40);
        await expectLater(cache.getIfPresent(1), completion('bar'));
        offset = const Duration(seconds: 61);
        await expectLater(cache.getIfPresent(1), completion(isNull));
      });
      clockTest('loaded value expires', () async {
        final cache = newAccessExpireCache(immediateLoader);
        await expectLater(cache.get(1), completion('1'));
        offset = const Duration(seconds: 20);
        await expectLater(cache.getIfPresent(1), completion('1'));
        offset = const Duration(seconds: 41);
        await expectLater(cache.getIfPresent(1), completion(isNull));
        await expectLater(cache.size(), completion(0));
      });
      clockTest('re-loaded value expires', () async {
        var counter = 0;
        final cache = newAccessExpireCache((key) {
          counter++;
          return immediateLoader(key);
        });
        await expectLater(cache.get(0), completion('0'));
        expect(counter, 1);
        offset = const Duration(seconds: 20);
        await expectLater(cache.get(0), completion('0'));
        expect(counter, 1);
        offset = const Duration(seconds: 41);
        await expectLater(cache.get(0), completion('0'));
        expect(counter, 2);
      });
      clockTest('reap expired items', () async {
        final cache = newAccessExpireCache(immediateLoader);
        await cache.set(1, '1');
        offset = const Duration(seconds: 120);
        await expectLater(cache.size(), completion(1));
        await expectLater(cache.reap(), completion(1));
        await expectLater(cache.size(), completion(0));
      });
    });
  });
  group('lru', () {
    Cache<int, String> newCache(Loader<int, String> loader) =>
        Cache.lru(loader: loader, maximumSize: 5);

    group('constructors', () {
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
    Cache<int, String> newCache(Loader<int, String> loader) =>
        Cache.fifo(loader: loader, maximumSize: 5);

    group('constructors', () {
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
