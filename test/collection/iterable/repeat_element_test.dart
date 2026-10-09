import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('repeat element', () {
    test('default', () {
      check(repeat(1).take(3)).deepEquals([1, 1, 1]);
      check(repeat('a').take(3)).deepEquals(['a', 'a', 'a']);
    });
    test('zero', () {
      check(repeat(2, count: 0)).isEmpty();
      check(repeat('b', count: 0)).isEmpty();
    });
    test('one', () {
      check(repeat(3, count: 1)).deepEquals([3]);
      check(repeat('c', count: 1)).deepEquals(['c']);
    });
    test('two', () {
      check(repeat(4, count: 2)).deepEquals([4, 4]);
      check(repeat('d', count: 2)).deepEquals(['d', 'd']);
    });
    test('tree', () {
      check(repeat(5, count: 3)).deepEquals([5, 5, 5]);
      check(repeat('e', count: 3)).deepEquals(['e', 'e', 'e']);
    });
    test('error', () {
      check(() => repeat(6, count: -1)).throws<RangeError>();
    });
    test('infinite', () {
      final iterable = repeat(42);
      check(iterable.isEmpty).isFalse();
      check(iterable.isNotEmpty).isTrue();
      check(() => iterable.length).throws<UnsupportedError>();
      check(() => iterable.last).throws<UnsupportedError>();
      check(() => iterable.lastWhere((e) => true)).throws<UnsupportedError>();
      check(() => iterable.single).throws<UnsupportedError>();
      check(() => iterable.singleWhere((e) => true)).throws<UnsupportedError>();
      check(iterable.toList).throws<UnsupportedError>();
      check(iterable.toSet).throws<UnsupportedError>();
    });
  });
}
