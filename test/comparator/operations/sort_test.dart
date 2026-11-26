import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('sorted', () {
    test('default', () {
      check(naturalInt.sorted([])).isEmpty;
      check(naturalInt.sorted([1])).deepEquals([1]);
      check(naturalInt.sorted([1, 2])).deepEquals([1, 2]);
      check(naturalInt.sorted([2, 1])).deepEquals([1, 2]);
      check(naturalInt.sorted([1, 2, 3])).deepEquals([1, 2, 3]);
      check(naturalInt.sorted([1, 3, 2])).deepEquals([1, 2, 3]);
      check(naturalInt.sorted([2, 1, 3])).deepEquals([1, 2, 3]);
      check(naturalInt.sorted([2, 3, 1])).deepEquals([1, 2, 3]);
      check(naturalInt.sorted([3, 1, 2])).deepEquals([1, 2, 3]);
      check(naturalInt.sorted([3, 2, 1])).deepEquals([1, 2, 3]);
    });

    test('stable', () {
      final input = IntegerRange(10).reversed
          .expand((x) => IntegerRange(10).map((y) => (x, y)));
      final actual = naturalInt
          .keyOf<(int, int)>((tuple) => tuple.$1)
          .sorted(input, stable: true);
      final expected = IntegerRange(10)
          .expand((x) => IntegerRange(10).map((y) => (x, y)));
      check(actual).deepEquals(expected);
    });

    test('copy', () {
      final input = [5, 4, 3, 2, 1];
      final output = naturalInt.sorted(input);
      check(input).not(.it()..identicalTo(output));
      check(input).deepEquals([5, 4, 3, 2, 1]);
      check(output).deepEquals([1, 2, 3, 4, 5]);
      check(() => output.add(6)).throws<UnsupportedError>();
    });

    test('growable', () {
      final output = naturalInt.sorted([3, 1, 2], growable: true);
      output.add(4);
      check(output).deepEquals([1, 2, 3, 4]);
    });

    test('copy range', () {
      final input = [5, 4, 3, 2, 1];
      final output = naturalInt.sorted(input, start: 1, end: 4);
      check(input).not(.it()..identicalTo(output));
      check(input).deepEquals([5, 4, 3, 2, 1]);
      check(output).deepEquals([5, 2, 3, 4, 1]);
    });
  });

  group('sort', () {
    test('in-place', () {
      final input = [5, 4, 3, 2, 1];
      naturalInt.sort(input);
      check(input).deepEquals([1, 2, 3, 4, 5]);
    });

    test('in-place stable', () {
      final input = IntegerRange(10).reversed
          .expand((x) => IntegerRange(10).map((y) => (x, y)))
          .toList();
      naturalInt
          .keyOf<(int, int)>((tuple) => tuple.$1)
          .sort(input, stable: true);
      final expected = IntegerRange(10)
          .expand((x) => IntegerRange(10).map((y) => (x, y)));
      check(input).deepEquals(expected);
    });

    test('in-place range', () {
      final input = [5, 4, 3, 2, 1];
      naturalInt.sort(input, start: 1, end: 4);
      check(input).deepEquals([5, 2, 3, 4, 1]);
    });

    test('invalid range', () {
      check(() => naturalInt.sort([1, 2, 3], start: -1)).throws<RangeError>();
      check(() => naturalInt.sort([1, 2, 3], end: 4)).throws<RangeError>();
      check(() => naturalInt.sort([1, 2, 3], start: 2, end: 1))
          .throws<RangeError>();
    });
  });
}
