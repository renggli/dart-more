import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('indexed', () {
    test('empty', () {
      final iterable = <int>[].indexed();
      check(iterable).isEmpty();
    });
    test('simple', () {
      final iterable = ['a', 'b', 'c'].indexed();
      check(iterable.map((each) => each.key)).deepEquals([0, 1, 2]);
      check(iterable.map((each) => each.value)).deepEquals(['a', 'b', 'c']);
      check(iterable.map((each) => each.toString()))
          .deepEquals(['MapEntry(0: a)', 'MapEntry(1: b)', 'MapEntry(2: c)']);
    });
    test('start', () {
      final actual = ['a', 'b']
          .indexed(start: 1)
          .map((each) => '${each.value}-${each.index}')
          .join(', ');
      const expected = 'a-1, b-2';
      check(actual).equals(expected);
    });
    test('step', () {
      final actual = ['a', 'b']
          .indexed(step: 2)
          .map((each) => '${each.value}-${each.index}')
          .join(', ');
      const expected = 'a-0, b-2';
      check(actual).equals(expected);
    });
    test('reverse', () {
      final actual = ['a', 'b']
          .indexed(start: 1, step: -1)
          .map((each) => '${each.value}-${each.index}')
          .join(', ');
      const expected = 'a-1, b-0';
      check(actual).equals(expected);
    });
    test('entries', () {
      final iterable = ['a', 'b', 'c'].indexed();
      check(Map.fromEntries(iterable)).deepEquals({0: 'a', 1: 'b', 2: 'c'});
    });
    test('offset (deprecated)', () {
      // ignore: deprecated_member_use_from_same_package
      final actual = ['a', 'b']
          .indexed(offset: 1)
          .map((each) => '${each.value}-${each.index}')
          .join(', ');
      const expected = 'a-1, b-2';
      check(actual).equals(expected);
    });
  });
}
