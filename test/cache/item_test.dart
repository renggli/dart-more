import 'package:checks/checks.dart';
import 'package:more/src/cache/item.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('item', () {
    test('sync value', () {
      final item = CacheItem<int>(42);
      check(item.value).equals(42);
      item.value = 43;
      check(item.value).equals(43);
    });
    test('async value', () async {
      final item = CacheItem<String>(Future.value('hello'));
      check(await item.value).equals('hello');
      item.value = 'world';
      check(await item.value).equals('world');
    });
  });
}
