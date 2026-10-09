import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;
  const naturalString = naturalComparable<String>;

  group('compound', () {
    test('thenCompare', () {
      final comparator = naturalInt
          .keyOf<String>((s) => s.length)
          .thenCompare(naturalString);
      verify(
        comparator,
        ['333', '1', '4444', '22'],
        ['1', '22', '333', '4444'],
      );
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

    test('toComparator', () {
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
    });
  });
}
