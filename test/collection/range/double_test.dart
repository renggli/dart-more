import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

import 'range_test_utils.dart';

void main() {
  group('constructor', () {
    test('empty', () {
      verifyRange(DoubleRange.empty, included: [], excluded: [0.0]);
    });
    test('of', () {
      verifyRange(const DoubleRange.of(), included: [], excluded: [0.0]);
      verifyRange(
        const DoubleRange.of(start: -2),
        included: [-2.0, -1.0],
        excluded: [-3.0, 0.0],
      );
      verifyRange(
        const DoubleRange.of(end: 2),
        included: [0.0, 1.0],
        excluded: [-1, 3],
      );
      verifyRange(
        const DoubleRange.of(start: 1, end: 3),
        included: [1.0, 2.0],
        excluded: [0.0, 3.0],
      );
      verifyRange(
        const DoubleRange.of(start: 3, end: 1),
        included: [3.0, 2.0],
        excluded: [1.0, 4.0],
      );
      verifyRange(
        const DoubleRange.of(start: 1, end: 5, step: 2),
        included: [1.0, 3.0],
        excluded: [2.0, 4.0, 5.0],
      );
      verifyRange(
        const DoubleRange.of(start: 5, end: 1, step: -2),
        included: [5.0, 3.0],
        excluded: [4.0, 2.0, 1.0],
      );
    });
    test('length', () {
      verifyRange(const DoubleRange.length(0), included: [], excluded: [0.0]);
      verifyRange(
        const DoubleRange.length(1),
        included: [0.0],
        excluded: [-1.0, 1.0],
      );
      verifyRange(
        const DoubleRange.length(2),
        included: [0.0, 1.0],
        excluded: [-1.0, 2.0],
      );
      verifyRange(
        const DoubleRange.length(2, start: 10),
        included: [10.0, 11.0],
        excluded: [-1.0, 2.0],
      );
      verifyRange(
        const DoubleRange.length(2, step: 2),
        included: [0.0, 2.0],
        excluded: [-1.0, 1.0, 3.0],
      );
      verifyRange(
        const DoubleRange.length(2, step: -2),
        included: [0.0, -2.0],
        excluded: [-3.0, -1.0, 1.0],
      );
    });
    test('1 argument', () {
      verifyRange(DoubleRange(0), included: [], excluded: [-1.0, 0.0, 1.0]);
      verifyRange(DoubleRange(1), included: [0.0], excluded: [-1.0, 1.0]);
      verifyRange(DoubleRange(2), included: [0.0, 1.0], excluded: [-1.0, 2.0]);
      verifyRange(
        DoubleRange(3),
        included: [0.0, 1.0, 2.0],
        excluded: [-1.0, 3.0],
      );
    });
    test('2 argument', () {
      verifyRange(DoubleRange(0, 0), included: [], excluded: [-1.0, 0.0, 1.0]);
      verifyRange(
        DoubleRange(0, 4),
        included: [0.0, 1.0, 2.0, 3.0],
        excluded: [-1.0, 4.0],
      );
      verifyRange(
        DoubleRange(4, 0),
        included: [4.0, 3.0, 2.0, 1.0],
        excluded: [5.0, 0.0],
      );
      verifyRange(
        DoubleRange(5, 9),
        included: [5.0, 6.0, 7.0, 8.0],
        excluded: [4.0, 9.0],
      );
      verifyRange(
        DoubleRange(9, 5),
        included: [9.0, 8.0, 7.0, 6.0],
        excluded: [10.0, 5.0],
      );
    });
    test('3 argument (positive step)', () {
      verifyRange(
        DoubleRange(0, 0, 1),
        included: [],
        excluded: [-1.0, 0.0, 1.0],
      );
      verifyRange(
        DoubleRange(2, 8, 1.5),
        included: [2.0, 3.5, 5.0, 6.5],
        excluded: [0.5, 3.0, 8.0],
      );
      verifyRange(
        DoubleRange(3, 8, 1.5),
        included: [3.0, 4.5, 6.0, 7.5],
        excluded: [1.5, 5.0, 9.0],
      );
      verifyRange(
        DoubleRange(4, 8, 1.5),
        included: [4.0, 5.5, 7.0],
        excluded: [3.5, 5, 6, 8.5],
      );
      verifyRange(
        DoubleRange(2, 7, 1.5),
        included: [2.0, 3.5, 5.0, 6.5],
        excluded: [0.5, 4.0, 8.0],
      );
      verifyRange(
        DoubleRange(2, 6, 1.5),
        included: [2.0, 3.5, 5.0],
        excluded: [0.5, 3.0, 4.0, 6.0],
      );
    });
    test('3 argument (negative step)', () {
      verifyRange(
        DoubleRange(0, 0, -1),
        included: [],
        excluded: [-1.0, 0.0, 1.0],
      );
      verifyRange(
        DoubleRange(8, 2, -1.5),
        included: [8.0, 6.5, 5.0, 3.5],
        excluded: [9.5, 6.0, 2.0],
      );
      verifyRange(
        DoubleRange(8, 3, -1.5),
        included: [8.0, 6.5, 5.0, 3.5],
        excluded: [9.5, 6.0, 2.0],
      );
      verifyRange(
        DoubleRange(8, 4, -1.5),
        included: [8.0, 6.5, 5.0],
        excluded: [9.5, 5.5, 3.5],
      );
      verifyRange(
        DoubleRange(7, 2, -1.5),
        included: [7.0, 5.5, 4.0, 2.5],
        excluded: [8.5, 3, 2.0],
      );
      verifyRange(
        DoubleRange(6, 2, -1.5),
        included: [6.0, 4.5, 3.0],
        excluded: [7.5, 4.0, 1.5],
      );
    });
    test('exceeding positive step size', () {
      for (var end = 31; end <= 40; end++) {
        verifyRange(
          DoubleRange(10, end.toDouble(), 10),
          included: [10.0, 20.0, 30.0],
          excluded: [5.0, 15.0, 25.0, 35.0, 40.0],
        );
      }
    });
    test('exceeding negative step size', () {
      for (var end = 9; end >= 0; end--) {
        verifyRange(
          DoubleRange(30, end.toDouble(), -10),
          included: [30.0, 20.0, 10.0],
          excluded: [0.0, 5.0, 15.0, 25.0, 35.0],
        );
      }
    });
    test('decimal positive step size', () {
      check(const DoubleRange.of(start: 1, end: 2, step: 0.1)).length
          .equals(10);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.2)).length.equals(5);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.3)).length.equals(4);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.4)).length.equals(3);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.5)).length.equals(2);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.6)).length.equals(2);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.7)).length.equals(2);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.8)).length.equals(2);
      check(const DoubleRange.of(start: 1, end: 2, step: 0.9)).length.equals(2);
      check(const DoubleRange.of(start: 1, end: 2, step: 1.0)).length.equals(1);
      check(const DoubleRange.of(start: 1, end: 2, step: 1.1)).length.equals(1);
      check(const DoubleRange.of(start: 1, end: 2, step: 1.2)).length.equals(1);
    });
    test('decimal negative step size', () {
      check(const DoubleRange.of(start: 2, end: 1, step: -0.1)).length
          .equals(10);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.2)).length
          .equals(5);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.3)).length
          .equals(4);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.4)).length
          .equals(3);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.5)).length
          .equals(2);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.6)).length
          .equals(2);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.7)).length
          .equals(2);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.8)).length
          .equals(2);
      check(const DoubleRange.of(start: 2, end: 1, step: -0.9)).length
          .equals(2);
      check(const DoubleRange.of(start: 2, end: 1, step: -1.0)).length
          .equals(1);
      check(const DoubleRange.of(start: 2, end: 1, step: -1.1)).length
          .equals(1);
      check(const DoubleRange.of(start: 2, end: 1, step: -1.2)).length
          .equals(1);
    });
    test('fractional positive step size', () {
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 1)).length
          .equals(1);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 2)).length
          .equals(2);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 3)).length
          .equals(3);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 4)).length
          .equals(4);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 5)).length
          .equals(5);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 6)).length
          .equals(6);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 7)).length
          .equals(7);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 8)).length
          .equals(8);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 9)).length
          .equals(9);
      check(const DoubleRange.of(start: 1, end: 2, step: 1 / 10)).length
          .equals(10);
    });
    test('fractional negative step size', () {
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 1)).length
          .equals(1);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 2)).length
          .equals(2);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 3)).length
          .equals(3);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 4)).length
          .equals(4);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 5)).length
          .equals(5);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 6)).length
          .equals(6);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 7)).length
          .equals(7);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 8)).length
          .equals(8);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 9)).length
          .equals(9);
      check(const DoubleRange.of(start: 2, end: 1, step: -1 / 10)).length
          .equals(10);
    });
    test('shorthand', () {
      verifyRange(
        0.0.to(3.0),
        included: [0.0, 1.0, 2.0],
        excluded: [-1.0, 3.0],
      );
      verifyRange(3.0.to(0.0), included: [3.0, 2.0, 1.0], excluded: [4.0, 0.0]);
      verifyRange(
        4.0.to(8.0, step: 1.5),
        included: [4.0, 5.5, 7.0],
        excluded: [5.0, 6.0, 6.5, 8.0],
      );
      verifyRange(
        8.0.to(4.0, step: -1.5),
        included: [8.0, 6.5, 5.0],
        excluded: [3.5, 4.0, 6.0, 7.5],
      );
    });
    test('invalid', () {
      check(() => DoubleRange(0, 0, 0)).throws<ArgumentError>();
      check(() => DoubleRange(null, 1)).throws<ArgumentError>();
      check(() => DoubleRange(null, null, 1)).throws<ArgumentError>();
    });
  });
  group('sublist', () {
    test('sublist (1 argument)', () {
      verifyRange(
        DoubleRange(3.0).sublist(0),
        included: [0.0, 1.0, 2.0],
        excluded: [-1.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).sublist(1),
        included: [1.0, 2.0],
        excluded: [-1.0, 0.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).sublist(2),
        included: [2.0],
        excluded: [-1.0, 0.0, 1.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).sublist(3),
        included: [],
        excluded: [-1.0, 0.0, 1.0, 2.0, 3.0],
      );
      check(() => DoubleRange(3.0).sublist(4)).throws<RangeError>();
    });
    test('sublist (2 arguments)', () {
      verifyRange(
        DoubleRange(3.0).sublist(0, 3),
        included: [0.0, 1.0, 2.0],
        excluded: [-1.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).sublist(0, 2),
        included: [0.0, 1.0],
        excluded: [-1.0, 2.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).sublist(0, 1),
        included: [0.0],
        excluded: [-1.0, 1.0, 2.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).sublist(0, 0),
        included: [],
        excluded: [-1.0, 0.0, 1.0, 2.0, 3.0],
      );
      check(() => DoubleRange(3.0).sublist(0, 4)).throws<RangeError>();
    });
    test('getRange', () {
      verifyRange(
        DoubleRange(3.0).getRange(0, 3),
        included: [0.0, 1.0, 2.0],
        excluded: [-1.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).getRange(0, 2),
        included: [0.0, 1.0],
        excluded: [-1.0, 2.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).getRange(0, 1),
        included: [0.0],
        excluded: [-1.0, 1.0, 2.0, 3.0],
      );
      verifyRange(
        DoubleRange(3.0).getRange(0, 0),
        included: [],
        excluded: [-1.0, 0.0, 1.0, 2.0, 3.0],
      );
      check(() => DoubleRange(3.0).getRange(0, 4)).throws<RangeError>();
    });
  });
  test('unmodifiable', () {
    final list = DoubleRange(1.0, 5.0);
    check(() => list[0] = 5.0).throws<UnsupportedError>();
    check(() => list.first = 5.0).throws<UnsupportedError>();
    check(() => list.last = 5.0).throws<UnsupportedError>();
    check(() => list.add(5.0)).throws<UnsupportedError>();
    check(() => list.addAll([5.0, 6.0])).throws<UnsupportedError>();
    check(list.clear).throws<UnsupportedError>();
    check(() => list.fillRange(2, 4, 5.0)).throws<UnsupportedError>();
    check(() => list.insert(2, 5.0)).throws<UnsupportedError>();
    check(() => list.insertAll(2, [5.0, 6.0])).throws<UnsupportedError>();
    check(() => list.length = 10).throws<UnsupportedError>();
    check(() => list.remove(5.0)).throws<UnsupportedError>();
    check(() => list.removeAt(2)).throws<UnsupportedError>();
    check(list.removeLast).throws<UnsupportedError>();
    check(() => list.removeRange(2, 4)).throws<UnsupportedError>();
    check(() => list.removeWhere((value) => true)).throws<UnsupportedError>();
    check(() => list.replaceRange(2, 4, [5.0, 6.0])).throws<UnsupportedError>();
    check(() => list.retainWhere((value) => false)).throws<UnsupportedError>();
    check(() => list.setAll(2, [5.0, 6.0])).throws<UnsupportedError>();
    check(() => list.setRange(2, 4, [5.0, 6.0])).throws<UnsupportedError>();
    check(list.sort).throws<UnsupportedError>();
  });
}
