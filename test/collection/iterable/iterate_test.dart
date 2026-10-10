import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('iterate', () {
    test('natural numbers', () {
      final iterable = iterate<int>(0, (a) => a + 1);
      check(iterable.take(10)).deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test('powers of two', () {
      final iterable = iterate<int>(1, (a) => 2 * a);
      check(iterable.take(10))
          .deepEquals([1, 2, 4, 8, 16, 32, 64, 128, 256, 512]);
    });
    test('infinite', () {
      final iterable = iterate<int>(1, (a) => 2 * a);
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
