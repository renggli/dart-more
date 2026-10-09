import 'package:checks/checks.dart';
import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:more/cache.dart';
import 'package:more/src/cache/expiry.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('expiry', () {
    late Duration offset;
    final current = DateTime(2020);
    setUp(() => offset = Duration.zero);
    @isTest
    void clockTest(String name, Future<void> Function() body) =>
        test(name, () => withClock(Clock(() => current.add(offset)), body));
    Cache<int, String> newUpdateExpireCache(Loader<int, String> loader) =>
        Cache.expiry(loader: loader, updateExpiry: const Duration(seconds: 20));
    Cache<int, String> newAccessExpireCache(Loader<int, String> loader) =>
        Cache.expiry(loader: loader, accessExpiry: const Duration(seconds: 20));
    statelessCacheTests(newUpdateExpireCache);
    persistentCacheTests(newUpdateExpireCache);
    group('update expire cache', () {
      clockTest('expire a set value after it has been updated', () async {
        final cache = newUpdateExpireCache(immediateLoader);
        check(await cache.set(1, '2')).equals('2');
        offset = const Duration(seconds: 20);
        check(await cache.getIfPresent(1)).equals('2');
        check(await cache.set(1, '3')).equals('3');
        offset = const Duration(seconds: 40);
        check(await cache.getIfPresent(1)).equals('3');
        offset = const Duration(seconds: 41);
        check(await cache.getIfPresent(1)).isNull();
      });
      clockTest('loaded value expires', () async {
        final cache = newUpdateExpireCache(immediateLoader);
        check(await cache.get(1)).equals('1');
        offset = const Duration(seconds: 20);
        check(await cache.getIfPresent(1)).equals('1');
        offset = const Duration(seconds: 40);
        check(await cache.getIfPresent(1)).isNull();
        check(await cache.size()).equals(0);
      });
      clockTest('re-loaded value expires', () async {
        var counter = 0;
        final cache = newUpdateExpireCache((key) {
          counter++;
          return immediateLoader(key);
        });
        check(await cache.get(0)).equals('0');
        check(counter).equals(1);
        offset = const Duration(seconds: 20);
        check(await cache.get(0)).equals('0');
        check(counter).equals(1);
        offset = const Duration(seconds: 21);
        check(await cache.get(0)).equals('0');
        check(counter).equals(2);
      });
      clockTest('reap expired items', () async {
        final cache = newUpdateExpireCache(immediateLoader);
        await cache.set(1, 'foo');
        offset = const Duration(seconds: 21);
        check(await cache.size()).equals(1);
        check(await cache.reap()).equals(1);
        check(await cache.size()).equals(0);
      });
    });
    group('access expire cache', () {
      clockTest('expire a set value after it has been updated', () async {
        final cache = newAccessExpireCache(immediateLoader);
        await cache.set(1, 'foo');
        offset = const Duration(seconds: 20);
        check(await cache.getIfPresent(1)).equals('foo');
        await cache.set(1, 'bar');
        offset = const Duration(seconds: 40);
        check(await cache.getIfPresent(1)).equals('bar');
        offset = const Duration(seconds: 61);
        check(await cache.getIfPresent(1)).isNull();
      });
      clockTest('loaded value expires', () async {
        final cache = newAccessExpireCache(immediateLoader);
        check(await cache.get(1)).equals('1');
        offset = const Duration(seconds: 20);
        check(await cache.getIfPresent(1)).equals('1');
        offset = const Duration(seconds: 41);
        check(await cache.getIfPresent(1)).isNull();
        check(await cache.size()).equals(0);
      });
      clockTest('re-loaded value expires', () async {
        var counter = 0;
        final cache = newAccessExpireCache((key) {
          counter++;
          return immediateLoader(key);
        });
        check(await cache.get(0)).equals('0');
        check(counter).equals(1);
        offset = const Duration(seconds: 20);
        check(await cache.get(0)).equals('0');
        check(counter).equals(1);
        offset = const Duration(seconds: 41);
        check(await cache.get(0)).equals('0');
        check(counter).equals(2);
      });
      clockTest('reap expired items', () async {
        final cache = newAccessExpireCache(immediateLoader);
        await cache.set(1, '1');
        offset = const Duration(seconds: 120);
        check(await cache.size()).equals(1);
        check(await cache.reap()).equals(1);
        check(await cache.size()).equals(0);
      });
    });
    group('both update and access expiry', () {
      clockTest('re-reads do not postpone update expiry', () async {
        var counter = 0;
        final cache = Cache<int, String>.expiry(
          loader: (k) {
            counter++;
            return 'val$counter';
          },
          updateExpiry: const Duration(seconds: 10),
          accessExpiry: const Duration(seconds: 4),
        );
        check(await cache.get(1)).equals('val1');
        offset = const Duration(seconds: 3);
        check(await cache.get(1)).equals('val1');
        offset = const Duration(seconds: 6);
        check(await cache.get(1)).equals('val1');
        offset = const Duration(seconds: 9);
        check(await cache.get(1)).equals('val1');
        offset = const Duration(seconds: 11);
        check(await cache.get(1)).equals('val2');
      });
      clockTest('idle access expires before update expiry', () async {
        var counter = 0;
        final cache = Cache<int, String>.expiry(
          loader: (k) {
            counter++;
            return 'val$counter';
          },
          updateExpiry: const Duration(seconds: 20),
          accessExpiry: const Duration(seconds: 3),
        );
        check(await cache.get(1)).equals('val1');
        offset = const Duration(seconds: 5);
        check(await cache.getIfPresent(1)).isNull();
        check(await cache.get(1)).equals('val2');
      });
    });
    group('ExpiryCacheItem', () {
      final t1 = DateTime(2020, 1, 1, 10, 0);
      final t2 = DateTime(2020, 1, 1, 10, 30);
      test('expiry with both deadlines (update before access)', () {
        final item = ExpiryCacheItem(
          'v',
          updateDeadline: t1,
          accessDeadline: t2,
        );
        check(item.expiry).equals(t1);
      });
      test('expiry with both deadlines (access before update)', () {
        final item = ExpiryCacheItem(
          'v',
          updateDeadline: t2,
          accessDeadline: t1,
        );
        check(item.expiry).equals(t1);
      });
      test('expiry with only update deadline', () {
        final item = ExpiryCacheItem('v', updateDeadline: t1);
        check(item.expiry).equals(t1);
      });
      test('expiry with only access deadline', () {
        final item = ExpiryCacheItem('v', accessDeadline: t2);
        check(item.expiry).equals(t2);
      });
      test('refreshUpdate with null duration', () {
        final item = ExpiryCacheItem('v', updateDeadline: t1);
        item.refreshUpdate(t2, null);
        check(item.updateDeadline).equals(t1);
      });
      test('refreshAccess with null duration', () {
        final item = ExpiryCacheItem('v', accessDeadline: t1);
        item.refreshAccess(t2, null);
        check(item.accessDeadline).equals(t1);
      });
      test('isExpired', () {
        final item = ExpiryCacheItem(
          'v',
          updateDeadline: t1,
          accessDeadline: t2,
        );
        check(item.isExpired(t1.subtract(const Duration(minutes: 1))))
            .isFalse();
        check(item.isExpired(t1.add(const Duration(minutes: 1)))).isTrue();
        check(item.isExpired(t2.add(const Duration(minutes: 1)))).isTrue();
      });
    });
  });
}
