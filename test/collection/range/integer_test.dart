import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

import 'range_test_utils.dart';

void main() {
  group('constructor', () {
    test('empty', () {
      verifyRange(IntegerRange.empty, included: [], excluded: [0]);
    });
    test('of', () {
      verifyRange(const IntegerRange.of(), included: [], excluded: [0]);
      verifyRange(
        const IntegerRange.of(start: -2),
        included: [-2, -1],
        excluded: [-3, 0],
      );
      verifyRange(
        const IntegerRange.of(end: 2),
        included: [0, 1],
        excluded: [-1, 3],
      );
      verifyRange(
        const IntegerRange.of(start: 1, end: 3),
        included: [1, 2],
        excluded: [0, 3],
      );
      verifyRange(
        const IntegerRange.of(start: 3, end: 1),
        included: [3, 2],
        excluded: [1, 4],
      );
      verifyRange(
        const IntegerRange.of(start: 1, end: 5, step: 2),
        included: [1, 3],
        excluded: [2, 4, 5],
      );
      verifyRange(
        const IntegerRange.of(start: 5, end: 1, step: -2),
        included: [5, 3],
        excluded: [4, 2, 1],
      );
    });
    test('length', () {
      verifyRange(const IntegerRange.length(0), included: [], excluded: [0]);
      verifyRange(
        const IntegerRange.length(1),
        included: [0],
        excluded: [-1, 1],
      );
      verifyRange(
        const IntegerRange.length(2),
        included: [0, 1],
        excluded: [-1, 2],
      );
      verifyRange(
        const IntegerRange.length(2, start: 10),
        included: [10, 11],
        excluded: [-1, 2],
      );
      verifyRange(
        const IntegerRange.length(2, step: 2),
        included: [0, 2],
        excluded: [-1, 1, 3],
      );
      verifyRange(
        const IntegerRange.length(2, step: -2),
        included: [0, -2],
        excluded: [-3, -1, 1],
      );
    });
    test('1 argument', () {
      verifyRange(IntegerRange(0), included: [], excluded: [-1, 0, 1]);
      verifyRange(IntegerRange(1), included: [0], excluded: [-1, 1]);
      verifyRange(IntegerRange(2), included: [0, 1], excluded: [-1, 2]);
      verifyRange(IntegerRange(3), included: [0, 1, 2], excluded: [-1, 3]);
    });
    test('2 arguments', () {
      verifyRange(IntegerRange(0, 0), included: [], excluded: [-1, 0, 1]);
      verifyRange(
        IntegerRange(0, 4),
        included: [0, 1, 2, 3],
        excluded: [-1, 4],
      );
      verifyRange(IntegerRange(4, 0), included: [4, 3, 2, 1], excluded: [5, 0]);
      verifyRange(IntegerRange(5, 9), included: [5, 6, 7, 8], excluded: [4, 9]);
      verifyRange(
        IntegerRange(9, 5),
        included: [9, 8, 7, 6],
        excluded: [10, 5],
      );
    });
    test('3 argument (positive step)', () {
      verifyRange(IntegerRange(0, 0, 1), included: [], excluded: [-1, 0, 1]);
      verifyRange(
        IntegerRange(2, 8, 2),
        included: [2, 4, 6],
        excluded: [0, 1, 3, 5, 7, 8],
      );
      verifyRange(
        IntegerRange(3, 8, 2),
        included: [3, 5, 7],
        excluded: [1, 2, 4, 6, 8, 9],
      );
      verifyRange(
        IntegerRange(4, 8, 2),
        included: [4, 6],
        excluded: [2, 3, 5, 7, 8],
      );
      verifyRange(
        IntegerRange(2, 7, 2),
        included: [2, 4, 6],
        excluded: [0, 1, 3, 5, 7, 8],
      );
      verifyRange(
        IntegerRange(2, 6, 2),
        included: [2, 4],
        excluded: [0, 1, 3, 5, 6, 7, 8],
      );
    });
    test('3 argument (negative step)', () {
      verifyRange(IntegerRange(0, 0, -1), included: [], excluded: [-1, 0, 1]);
      verifyRange(
        IntegerRange(8, 2, -2),
        included: [8, 6, 4],
        excluded: [2, 3, 5, 7, 9, 10],
      );
      verifyRange(
        IntegerRange(8, 3, -2),
        included: [8, 6, 4],
        excluded: [2, 3, 5, 7, 9, 10],
      );
      verifyRange(
        IntegerRange(8, 4, -2),
        included: [8, 6],
        excluded: [2, 3, 4, 5, 7, 9, 10],
      );
      verifyRange(
        IntegerRange(7, 2, -2),
        included: [7, 5, 3],
        excluded: [1, 2, 4, 6, 8, 9],
      );
      verifyRange(
        IntegerRange(6, 2, -2),
        included: [6, 4],
        excluded: [2, 3, 5, 7, 8, 9],
      );
    });
    test('positive step size', () {
      for (var end = 31; end <= 40; end++) {
        verifyRange(
          IntegerRange(10, end, 10),
          included: [10, 20, 30],
          excluded: [5, 15, 25, 35, 40],
        );
      }
    });
    test('negative step size', () {
      for (var end = 9; end >= 0; end--) {
        verifyRange(
          IntegerRange(30, end, -10),
          included: [30, 20, 10],
          excluded: [0, 5, 15, 25, 35],
        );
      }
    });
    test('length with positive step size', () {
      check(const IntegerRange.of(end: 12, step: 2)).length.equals(6);
      check(const IntegerRange.of(end: 12, step: 3)).length.equals(4);
      check(const IntegerRange.of(end: 12, step: 4)).length.equals(3);
      check(const IntegerRange.of(end: 12, step: 6)).length.equals(2);
    });
    test('length with negative step size', () {
      check(const IntegerRange.of(start: 12, step: -2)).length.equals(6);
      check(const IntegerRange.of(start: 12, step: -3)).length.equals(4);
      check(const IntegerRange.of(start: 12, step: -4)).length.equals(3);
      check(const IntegerRange.of(start: 12, step: -6)).length.equals(2);
    });
    test('shorthand', () {
      verifyRange(0.to(3), included: [0, 1, 2], excluded: [-1, 3]);
      verifyRange(3.to(0), included: [3, 2, 1], excluded: [4, 0]);
      verifyRange(
        2.to(8, step: 2),
        included: [2, 4, 6],
        excluded: [1, 3, 5, 7, 8],
      );
      verifyRange(
        8.to(2, step: -2),
        included: [8, 6, 4],
        excluded: [2, 3, 5, 7, 9],
      );
    });
    test('stress', () {
      final random = Random(1618033);
      for (var i = 0; i < 250; i++) {
        final start = random.nextInt(0xffff) - 0xffff ~/ 2;
        final end = random.nextInt(0xffff) - 0xffff ~/ 2;
        final step = start < end
            ? 1 + random.nextInt(0xfff)
            : -1 - random.nextInt(0xfff);
        final expected = start < end
            ? <int>[for (var j = start; j < end; j += step) j]
            : <int>[for (var j = start; j > end; j += step) j];
        verifyRange(
          IntegerRange(start, end, step),
          included: expected,
          excluded: [],
        );
      }
    });
    test('invalid', () {
      check(() => IntegerRange(0, 0, 0)).throws<ArgumentError>();
      check(() => IntegerRange(null, 1)).throws<ArgumentError>();
      check(() => IntegerRange(null, null, 1)).throws<ArgumentError>();
    });
    group('indices', () {
      test('empty', () {
        verifyRange(<int>[].indices(), included: [], excluded: [0, 1, 2]);
        verifyRange(
          <int>[].indices(step: -1),
          included: [],
          excluded: [0, 1, 2],
        );
      });
      test('default', () {
        verifyRange(
          [1, 2, 3].indices(),
          included: [0, 1, 2],
          excluded: [-1, 3],
        );
        verifyRange(
          [1, 2, 3].indices(step: -1),
          included: [2, 1, 0],
          excluded: [-1, 3],
        );
      });
      test('step', () {
        verifyRange(
          [1, 2, 3].indices(step: 2),
          included: [0, 2],
          excluded: [-1, 1, 3],
        );
        verifyRange(
          [1, 2, 3, 4].indices(step: 2),
          included: [0, 2],
          excluded: [-1, 1, 3],
        );
        verifyRange(
          [1, 2, 3].indices(step: -2),
          included: [2, 0],
          excluded: [-1, 1, 3],
        );
        verifyRange(
          [1, 2, 3, 4].indices(step: -2),
          included: [3, 1],
          excluded: [0, 2, 4, 6],
        );
      });
    });
  });
  group('sublist', () {
    test('sublist (1 argument)', () {
      verifyRange(
        IntegerRange(3).sublist(0),
        included: [0, 1, 2],
        excluded: [-1, 3],
      );
      verifyRange(
        IntegerRange(3).sublist(1),
        included: [1, 2],
        excluded: [-1, 0, 3],
      );
      verifyRange(
        IntegerRange(3).sublist(2),
        included: [2],
        excluded: [-1, 0, 1, 3],
      );
      verifyRange(
        IntegerRange(3).sublist(3),
        included: [],
        excluded: [-1, 0, 1, 2, 3],
      );
      check(() => IntegerRange(3).sublist(4)).throws<RangeError>();
    });
    test('sublist (2 arguments)', () {
      verifyRange(
        IntegerRange(3).sublist(0, 3),
        included: [0, 1, 2],
        excluded: [-1, 3],
      );
      verifyRange(
        IntegerRange(3).sublist(0, 2),
        included: [0, 1],
        excluded: [-1, 2, 3],
      );
      verifyRange(
        IntegerRange(3).sublist(0, 1),
        included: [0],
        excluded: [-1, 1, 2, 3],
      );
      verifyRange(
        IntegerRange(3).sublist(0, 0),
        included: [],
        excluded: [-1, 0, 1, 2, 3],
      );
      check(() => IntegerRange(3).sublist(0, 4)).throws<RangeError>();
    });
    test('getRange', () {
      verifyRange(
        IntegerRange(3).getRange(0, 3),
        included: [0, 1, 2],
        excluded: [-1, 3],
      );
      verifyRange(
        IntegerRange(3).getRange(0, 2),
        included: [0, 1],
        excluded: [-1, 2, 3],
      );
      verifyRange(
        IntegerRange(3).getRange(0, 1),
        included: [0],
        excluded: [-1, 1, 2, 3],
      );
      verifyRange(
        IntegerRange(3).getRange(0, 0),
        included: [],
        excluded: [-1, 0, 1, 2, 3],
      );
      check(() => IntegerRange(3).getRange(0, 4)).throws<RangeError>();
    });
  });
  test('unmodifiable', () {
    final list = IntegerRange(1, 5);
    check(() => list[0] = 5).throws<UnsupportedError>();
    check(() => list.first = 5).throws<UnsupportedError>();
    check(() => list.last = 5).throws<UnsupportedError>();
    check(() => list.add(5)).throws<UnsupportedError>();
    check(() => list.addAll([5, 6])).throws<UnsupportedError>();
    check(list.clear).throws<UnsupportedError>();
    check(() => list.fillRange(2, 4, 5)).throws<UnsupportedError>();
    check(() => list.insert(2, 5)).throws<UnsupportedError>();
    check(() => list.insertAll(2, [5, 6])).throws<UnsupportedError>();
    check(() => list.length = 10).throws<UnsupportedError>();
    check(() => list.remove(5)).throws<UnsupportedError>();
    check(() => list.removeAt(2)).throws<UnsupportedError>();
    check(list.removeLast).throws<UnsupportedError>();
    check(() => list.removeRange(2, 4)).throws<UnsupportedError>();
    check(() => list.removeWhere((value) => true)).throws<UnsupportedError>();
    check(() => list.replaceRange(2, 4, [5, 6])).throws<UnsupportedError>();
    check(() => list.retainWhere((value) => false)).throws<UnsupportedError>();
    check(() => list.setAll(2, [5, 6])).throws<UnsupportedError>();
    check(() => list.setRange(2, 4, [5, 6])).throws<UnsupportedError>();
    check(list.shuffle).throws<UnsupportedError>();
    check(list.sort).throws<UnsupportedError>();
  });
}
