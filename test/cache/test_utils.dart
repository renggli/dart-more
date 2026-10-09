import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

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
    check(await cache.size()).equals(0);
  });
  test('no present value', () async {
    final cache = newCache(immediateFailingLoader);
    check(await cache.getIfPresent(1)).isNull();
  });
  test('set present value', () async {
    final cache = newCache(immediateLoader);
    check(await cache.set(1, '2')).equals('2');
  });
  test('load immediate value', () async {
    final cache = newCache(immediateLoader);
    check(await cache.get(1)).equals('1');
  });
  test('load immediate failing value', () async {
    final cache = newCache(immediateFailingLoader);
    await check(cache.get(1)).throws<StateError>();
  });
  test('load future value', () async {
    final cache = newCache(futureLoader);
    check(await cache.get(1)).equals('1');
  });
  test('load future failing value', () async {
    final cache = newCache(futureFailingLoader);
    await check(cache.get(1)).throws<StateError>();
  });
  test('load future delayed value', () async {
    final cache = newCache(futureDelayedLoader);
    check(await cache.get(1)).equals('1');
  });
  test('invalidate empty', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.invalidate(1);
    check(await cache.size()).equals(0);
  });
  test('invalidate all empty', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.invalidateAll();
    check(await cache.size()).equals(0);
  });
  test('reap is a no-op', () async {
    final cache = newCache(immediateFailingLoader);
    check(await cache.reap()).equals(0);
  });
  test('toString', () {
    final cache = newCache(immediateFailingLoader);
    check(cache.toString()).startsWith(cache.runtimeType.toString());
  });
}

void cacheEvictionTest(
  NewCache<int, String> newCache,
  String name,
  List<int> load,
  List<int> present,
) {
  final absent = <int>{}
    ..addAll(load)
    ..removeAll(present);

  test(name, () async {
    final cache = newCache(immediateLoader);
    for (final key in load) {
      check(await cache.get(key)).equals('$key');
    }
    for (final key in present) {
      check(await cache.getIfPresent(key)).equals('$key');
    }
    for (final key in absent) {
      check(await cache.getIfPresent(key)).isNull();
    }
  });
}

// Basic tests that should pass on any persistent cache
// (as long as no expiry kicks in).
void persistentCacheTests(NewCache<int, String> newCache) {
  test('get and set', () async {
    final cache = newCache(immediateLoader);
    check(await cache.get(1)).equals('1');
    check(await cache.set(1, 'foo')).equals('foo');
    check(await cache.getIfPresent(1)).equals('foo');
  });
  test('load throwing value has no side-effect', () async {
    final cache = newCache(immediateFailingLoader);
    await check(cache.get(1)).throws<StateError>();
    check(await cache.getIfPresent(1)).isNull();
  });
  test('set and get', () async {
    final cache = newCache(immediateFailingLoader);
    check(await cache.set(1, 'foo')).equals('foo');
    check(await cache.get(1)).equals('foo');
  });
  test('set and size', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    check(await cache.size()).equals(1);
  });
  test('set, invalidate, get', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    await cache.invalidate(1);
    check(await cache.getIfPresent(1)).isNull();
  });
  test('set, invalidate all, get', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    await cache.invalidateAll();
    check(await cache.getIfPresent(1)).isNull();
  });
  test('get with immediate value is persistent', () async {
    final cache = newCache(immediateLoader);
    check(await cache.get(1)).equals('1');
    check(await cache.getIfPresent(1)).equals('1');
  });
  test('get with future value is persistent', () async {
    final cache = newCache(futureLoader);
    check(await cache.get(1)).equals('1');
    check(await cache.getIfPresent(1)).equals('1');
  });
  test('get with delayed value is persistent', () async {
    final cache = newCache(futureDelayedLoader);
    check(await cache.get(1)).equals('1');
    check(await cache.getIfPresent(1)).equals('1');
  });
  test('get with invalidated key is not persistent', () async {
    final cache = newCache(futureDelayedLoader);
    final loaded1 = cache.get(1);
    final loaded2 = cache.get(2);
    await cache.invalidate(2);
    await loaded1;
    await loaded2;
    check(await cache.getIfPresent(1)).equals('1');
    check(await cache.getIfPresent(2)).isNull();
  });
  test('get with invalidated cache is not persistent', () async {
    final cache = newCache(futureDelayedLoader);
    final loaded = cache.get(1);
    await cache.invalidateAll();
    await loaded;
    check(await cache.getIfPresent(1)).isNull();
  });
  test('reap is invariant', () async {
    final cache = newCache(immediateFailingLoader);
    await cache.set(1, 'foo');
    check(await cache.reap()).equals(0);
    check(await cache.size()).equals(1);
  });
}
