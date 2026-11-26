import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;
  const naturalString = naturalComparable<String>;

  test('thenCompare', () {
    final comparator = naturalInt
        .keyOf<String>((s) => s.length)
        .thenCompare(naturalString);
    verify(comparator, ['333', '1', '4444', '22'], ['1', '22', '333', '4444']);
    verify(
      comparator,
      ['2', '333', '4444', '1', '22'],
      ['1', '2', '22', '333', '4444'],
    );
    verify(
      comparator,
      ['33', '333', '2', '22', '1', '4444'],
      ['1', '2', '22', '33', '333', '4444'],
    );
    verify(
      comparator,
      ['4444', '44', '2', '1', '333', '22', '33'],
      ['1', '2', '22', '33', '44', '333', '4444'],
    );
  });

  group('toComparator', () {
    test('default', () {
      final comparator = [
        naturalInt.keyOf<List<int>>((value) => value[0]),
        naturalInt.keyOf<List<int>>((value) => value[1]),
        naturalInt.keyOf<List<int>>((value) => value[2]),
      ].toComparator();
      verify(
        comparator,
        [
          [2, 0, 0],
          [1, 0, 0],
        ],
        [
          [1, 0, 0],
          [2, 0, 0],
        ],
      );
      verify(
        comparator,
        [
          [0, 2, 0],
          [0, 1, 0],
        ],
        [
          [0, 1, 0],
          [0, 2, 0],
        ],
      );
      verify(
        comparator,
        [
          [0, 0, 2],
          [0, 0, 1],
        ],
        [
          [0, 0, 1],
          [0, 0, 2],
        ],
      );
      check(comparator([1, 2, 3], [1, 2, 3])).equals(0);
    });

    test('empty', () {
      final comparator = <Comparator<int>>[].toComparator();
      check(comparator(1, 2)).equals(0);
      check(comparator(2, 1)).equals(0);
    });

    test('single', () {
      final comparator = [naturalInt].toComparator();
      check(comparator(1, 2)).isLessThan(0);
      check(comparator(2, 1)).isGreaterThan(0);
      check(comparator(1, 1)).equals(0);
    });

    test('lazy iterable evaluated once', () {
      var calls = 0;
      final comparator = [0, 1].map((index) {
        calls++;
        return naturalInt.keyOf<List<int>>((value) => value[index]);
      }).toComparator();
      check(calls).equals(2);
      check(comparator([1, 2], [1, 3])).isLessThan(0);
      check(comparator([1, 2], [2, 1])).isLessThan(0);
      check(calls).equals(2);
    });
  });
}
