import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('groupBy', () {
    final example = 'aaaabbbccdaabbb'.toList();

    test('groupBy empty', () {
      final iterable = <int>[].groupBy<int>();
      check(iterable).isEmpty();
    });
    test('groupBy basic', () {
      final iterable = example.groupBy<String>();
      check(iterable.map((each) => each.key))
          .deepEquals(['a', 'b', 'c', 'd', 'a', 'b']);
      check(iterable.map((each) => each.values)).deepEquals([
        ['a', 'a', 'a', 'a'],
        ['b', 'b', 'b'],
        ['c', 'c'],
        ['d'],
        ['a', 'a'],
        ['b', 'b', 'b'],
      ]);
    });
    test('groupBy mapping', () {
      final iterable = example.reversed.groupBy((key) => key.codeUnitAt(0));
      check(iterable.map((each) => each.key))
          .deepEquals([98, 97, 100, 99, 98, 97]);
      check(iterable.map((each) => each.values)).deepEquals([
        ['b', 'b', 'b'],
        ['a', 'a'],
        ['d'],
        ['c', 'c'],
        ['b', 'b', 'b'],
        ['a', 'a', 'a', 'a'],
      ]);
    });
  });
}
