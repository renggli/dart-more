// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/number.dart';
import 'package:test/test.dart';

void verifyRange<T>(
  Range<T> range, {
  required List<T> included,
  required List<T> excluded,
  bool reverse = true,
}) {
  expect(range, included);
  expect(range.length, included.length);
  if (reverse) {
    verifyRange(
      range.reversed,
      included: included.reversed.toList(),
      excluded: excluded,
      reverse: false,
    );
  }
  if (included.isEmpty) {
    expect(range.isEmpty, isTrue);
  } else {
    expect(range.isNotEmpty, isTrue);
    expect(range.start, included.first);
    expect(range.start, isNot(range.end));
    expect(range.first, included.first);
    expect(range.last, included.last);
  }
  // Test included indexes.
  for (final each in included.indexed()) {
    expect(each.value, range[each.index]);
    expect(range.contains(each.value), isTrue);
    expect(range.indexOf(each.value), each.index);
    expect(range.indexOf(each.value, each.index), each.index);
    expect(range.indexOf(each.value, -1), each.index);
    expect(range.lastIndexOf(each.value), each.index);
    expect(range.lastIndexOf(each.value, each.index), each.index);
    expect(range.lastIndexOf(each.value, included.length), each.index);
  }
  // Test excluded indexes.
  for (final value in excluded) {
    expect(range.contains(value), isFalse);
    expect(range.indexOf(value), -1);
    expect(range.indexOf(value, 0), -1);
    expect(range.indexOf(value, range.length), -1);
    expect(range.lastIndexOf(value), -1);
    expect(range.lastIndexOf(value, 0), -1);
    expect(range.lastIndexOf(value, range.length), -1);
  }
  // Validate forward iteration.
  final forward1 = range.iterator;
  expect(forward1.range, same(range));
  final forward2 = included.iterator;
  while (true) {
    final hasMore = forward1.moveNext();
    expect(hasMore, forward2.moveNext());
    if (hasMore == false) break;
    expect(forward1.current, forward2.current);
  }
  // Validate backward iteration.
  final backward1 = range.iteratorAtEnd;
  expect(backward1.range, same(range));
  final backward2 = included.reversed.iterator;
  while (true) {
    final hasMore = backward1.movePrevious();
    expect(hasMore, backward2.moveNext());
    if (hasMore == false) break;
    expect(backward1.current, backward2.current);
  }
  // Test range errors.
  expect(() => range[-1], throwsRangeError);
  expect(() => range[included.length], throwsRangeError);
}

void main() {
  group('int', () {
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
        verifyRange(
          IntegerRange(4, 0),
          included: [4, 3, 2, 1],
          excluded: [5, 0],
        );
        verifyRange(
          IntegerRange(5, 9),
          included: [5, 6, 7, 8],
          excluded: [4, 9],
        );
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
        expect(const IntegerRange.of(end: 12, step: 2), hasLength(6));
        expect(const IntegerRange.of(end: 12, step: 3), hasLength(4));
        expect(const IntegerRange.of(end: 12, step: 4), hasLength(3));
        expect(const IntegerRange.of(end: 12, step: 6), hasLength(2));
      });
      test('length with negative step size', () {
        expect(const IntegerRange.of(start: 12, step: -2), hasLength(6));
        expect(const IntegerRange.of(start: 12, step: -3), hasLength(4));
        expect(const IntegerRange.of(start: 12, step: -4), hasLength(3));
        expect(const IntegerRange.of(start: 12, step: -6), hasLength(2));
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
        expect(() => IntegerRange(0, 0, 0), throwsArgumentError);
        expect(() => IntegerRange(null, 1), throwsArgumentError);
        expect(() => IntegerRange(null, null, 1), throwsArgumentError);
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
        expect(() => IntegerRange(3).sublist(4), throwsRangeError);
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
        expect(() => IntegerRange(3).sublist(0, 4), throwsRangeError);
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
        expect(() => IntegerRange(3).getRange(0, 4), throwsRangeError);
      });
    });
    test('unmodifiable', () {
      final list = IntegerRange(1, 5);
      expect(() => list[0] = 5, throwsUnsupportedError);
      expect(() => list.first = 5, throwsUnsupportedError);
      expect(() => list.last = 5, throwsUnsupportedError);
      expect(() => list.add(5), throwsUnsupportedError);
      expect(() => list.addAll([5, 6]), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(() => list.fillRange(2, 4, 5), throwsUnsupportedError);
      expect(() => list.insert(2, 5), throwsUnsupportedError);
      expect(() => list.insertAll(2, [5, 6]), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(5), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(() => list.replaceRange(2, 4, [5, 6]), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
      expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
      expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
      expect(() => list.shuffle(), throwsUnsupportedError);
      expect(() => list.sort(), throwsUnsupportedError);
    });
  });
  group('double', () {
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
        verifyRange(
          DoubleRange(2),
          included: [0.0, 1.0],
          excluded: [-1.0, 2.0],
        );
        verifyRange(
          DoubleRange(3),
          included: [0.0, 1.0, 2.0],
          excluded: [-1.0, 3.0],
        );
      });
      test('2 argument', () {
        verifyRange(
          DoubleRange(0, 0),
          included: [],
          excluded: [-1.0, 0.0, 1.0],
        );
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
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 0.1),
          hasLength(10),
        );
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.2), hasLength(5));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.3), hasLength(4));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.4), hasLength(3));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.5), hasLength(2));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.6), hasLength(2));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.7), hasLength(2));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.8), hasLength(2));
        expect(const DoubleRange.of(start: 1, end: 2, step: 0.9), hasLength(2));
        expect(const DoubleRange.of(start: 1, end: 2, step: 1.0), hasLength(1));
        expect(const DoubleRange.of(start: 1, end: 2, step: 1.1), hasLength(1));
        expect(const DoubleRange.of(start: 1, end: 2, step: 1.2), hasLength(1));
      });
      test('decimal negative step size', () {
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.1),
          hasLength(10),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.2),
          hasLength(5),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.3),
          hasLength(4),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.4),
          hasLength(3),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.5),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.6),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.7),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.8),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -0.9),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1.0),
          hasLength(1),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1.1),
          hasLength(1),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1.2),
          hasLength(1),
        );
      });
      test('fractional positive step size', () {
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 1),
          hasLength(1),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 2),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 3),
          hasLength(3),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 4),
          hasLength(4),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 5),
          hasLength(5),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 6),
          hasLength(6),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 7),
          hasLength(7),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 8),
          hasLength(8),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 9),
          hasLength(9),
        );
        expect(
          const DoubleRange.of(start: 1, end: 2, step: 1 / 10),
          hasLength(10),
        );
      });
      test('fractional negative step size', () {
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 1),
          hasLength(1),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 2),
          hasLength(2),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 3),
          hasLength(3),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 4),
          hasLength(4),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 5),
          hasLength(5),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 6),
          hasLength(6),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 7),
          hasLength(7),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 8),
          hasLength(8),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 9),
          hasLength(9),
        );
        expect(
          const DoubleRange.of(start: 2, end: 1, step: -1 / 10),
          hasLength(10),
        );
      });
      test('shorthand', () {
        verifyRange(
          0.0.to(3.0),
          included: [0.0, 1.0, 2.0],
          excluded: [-1.0, 3.0],
        );
        verifyRange(
          3.0.to(0.0),
          included: [3.0, 2.0, 1.0],
          excluded: [4.0, 0.0],
        );
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
        expect(() => DoubleRange(0, 0, 0), throwsArgumentError);
        expect(() => DoubleRange(null, 1), throwsArgumentError);
        expect(() => DoubleRange(null, null, 1), throwsArgumentError);
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
        expect(() => DoubleRange(3.0).sublist(4), throwsRangeError);
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
        expect(() => DoubleRange(3.0).sublist(0, 4), throwsRangeError);
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
        expect(() => DoubleRange(3.0).getRange(0, 4), throwsRangeError);
      });
    });
    test('unmodifiable', () {
      final list = DoubleRange(1.0, 5.0);
      expect(() => list[0] = 5.0, throwsUnsupportedError);
      expect(() => list.first = 5.0, throwsUnsupportedError);
      expect(() => list.last = 5.0, throwsUnsupportedError);
      expect(() => list.add(5.0), throwsUnsupportedError);
      expect(() => list.addAll([5.0, 6.0]), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(() => list.fillRange(2, 4, 5.0), throwsUnsupportedError);
      expect(() => list.insert(2, 5.0), throwsUnsupportedError);
      expect(() => list.insertAll(2, [5.0, 6.0]), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(5.0), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(() => list.replaceRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
      expect(() => list.setAll(2, [5.0, 6.0]), throwsUnsupportedError);
      expect(() => list.setRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
      expect(() => list.sort(), throwsUnsupportedError);
    });
  });
  group('BigInt', () {
    List<BigInt> toBigIntList(List<int> values) =>
        values.map(BigInt.from).toList();
    group('constructor', () {
      test('empty', () {
        verifyRange(
          BigIntRange.empty,
          included: <BigInt>[],
          excluded: toBigIntList([0]),
        );
      });
      test('of', () {
        verifyRange(
          BigIntRange.of(),
          included: <BigInt>[],
          excluded: toBigIntList([0]),
        );
        verifyRange(
          BigIntRange.of(start: BigInt.from(-2)),
          included: toBigIntList([-2, -1]),
          excluded: toBigIntList([-3, 0]),
        );
        verifyRange(
          BigIntRange.of(end: BigInt.from(2)),
          included: toBigIntList([0, 1]),
          excluded: toBigIntList([-1, 3]),
        );
        verifyRange(
          BigIntRange.of(start: BigInt.from(1), end: BigInt.from(3)),
          included: toBigIntList([1, 2]),
          excluded: toBigIntList([0, 3]),
        );
        verifyRange(
          BigIntRange.of(start: BigInt.from(3), end: BigInt.from(1)),
          included: toBigIntList([3, 2]),
          excluded: toBigIntList([1, 4]),
        );
        verifyRange(
          BigIntRange.of(
            start: BigInt.from(1),
            end: BigInt.from(5),
            step: BigInt.from(2),
          ),
          included: toBigIntList([1, 3]),
          excluded: toBigIntList([2, 4, 5]),
        );
        verifyRange(
          BigIntRange.of(
            start: BigInt.from(5),
            end: BigInt.from(1),
            step: BigInt.from(-2),
          ),
          included: toBigIntList([5, 3]),
          excluded: toBigIntList([4, 2, 1]),
        );
      });
      test('length', () {
        verifyRange(
          BigIntRange.length(0),
          included: toBigIntList([]),
          excluded: toBigIntList([0]),
        );
        verifyRange(
          BigIntRange.length(1),
          included: toBigIntList([0]),
          excluded: toBigIntList([-1, 1]),
        );
        verifyRange(
          BigIntRange.length(2),
          included: toBigIntList([0, 1]),
          excluded: toBigIntList([-1, 2]),
        );
        verifyRange(
          BigIntRange.length(2, start: BigInt.from(10)),
          included: toBigIntList([10, 11]),
          excluded: toBigIntList([-1, 2]),
        );
        verifyRange(
          BigIntRange.length(2, step: BigInt.from(2)),
          included: toBigIntList([0, 2]),
          excluded: toBigIntList([-1, 1, 3]),
        );
        verifyRange(
          BigIntRange.length(2, step: BigInt.from(-2)),
          included: toBigIntList([0, -2]),
          excluded: toBigIntList([-3, -1, 1]),
        );
      });
      test('1 argument', () {
        verifyRange(
          BigIntRange(BigInt.zero),
          included: <BigInt>[],
          excluded: toBigIntList([-1, 0, 1]),
        );
        verifyRange(
          BigIntRange(BigInt.one),
          included: toBigIntList([0]),
          excluded: toBigIntList([-1, 1]),
        );
        verifyRange(
          BigIntRange(BigInt.from(2)),
          included: toBigIntList([0, 1]),
          excluded: toBigIntList([-1, 2]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)),
          included: toBigIntList([0, 1, 2]),
          excluded: toBigIntList([-1, 3]),
        );
      });
      test('2 argument', () {
        verifyRange(
          BigIntRange(BigInt.zero, BigInt.zero),
          included: <BigInt>[],
          excluded: toBigIntList([-1, 0, 1]),
        );
        verifyRange(
          BigIntRange(BigInt.zero, BigInt.from(4)),
          included: toBigIntList([0, 1, 2, 3]),
          excluded: toBigIntList([-1, 4]),
        );
        verifyRange(
          BigIntRange(BigInt.from(4), BigInt.zero),
          included: toBigIntList([4, 3, 2, 1]),
          excluded: toBigIntList([5, 0]),
        );
        verifyRange(
          BigIntRange(BigInt.from(5), BigInt.from(9)),
          included: toBigIntList([5, 6, 7, 8]),
          excluded: toBigIntList([4, 9]),
        );
        verifyRange(
          BigIntRange(BigInt.from(9), BigInt.from(5)),
          included: toBigIntList([9, 8, 7, 6]),
          excluded: toBigIntList([10, 5]),
        );
      });
      test('3 argument (positive step)', () {
        verifyRange(
          BigIntRange(BigInt.zero, BigInt.zero, BigInt.one),
          included: <BigInt>[],
          excluded: toBigIntList([-1, 0, 1]),
        );
        verifyRange(
          BigIntRange(BigInt.from(2), BigInt.from(8), BigInt.two),
          included: toBigIntList([2, 4, 6]),
          excluded: toBigIntList([0, 1, 3, 5, 7, 8]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3), BigInt.from(8), BigInt.two),
          included: toBigIntList([3, 5, 7]),
          excluded: toBigIntList([1, 2, 4, 6, 8, 9]),
        );
        verifyRange(
          BigIntRange(BigInt.from(4), BigInt.from(8), BigInt.two),
          included: toBigIntList([4, 6]),
          excluded: toBigIntList([2, 3, 5, 7, 8]),
        );
        verifyRange(
          BigIntRange(BigInt.from(2), BigInt.from(7), BigInt.two),
          included: toBigIntList([2, 4, 6]),
          excluded: toBigIntList([0, 1, 3, 5, 7, 8]),
        );
        verifyRange(
          BigIntRange(BigInt.from(2), BigInt.from(6), BigInt.two),
          included: toBigIntList([2, 4]),
          excluded: toBigIntList([0, 1, 3, 5, 6, 7, 8]),
        );
      });
      test('3 argument (negative step)', () {
        verifyRange(
          BigIntRange(BigInt.zero, BigInt.zero, BigIntExtension.negativeOne),
          included: <BigInt>[],
          excluded: toBigIntList([-1, 0, 1]),
        );
        verifyRange(
          BigIntRange(
            BigInt.from(8),
            BigInt.from(2),
            BigIntExtension.negativeTwo,
          ),
          included: toBigIntList([8, 6, 4]),
          excluded: toBigIntList([2, 3, 5, 7, 9, 10]),
        );
        verifyRange(
          BigIntRange(
            BigInt.from(8),
            BigInt.from(3),
            BigIntExtension.negativeTwo,
          ),
          included: toBigIntList([8, 6, 4]),
          excluded: toBigIntList([2, 3, 5, 7, 9, 10]),
        );
        verifyRange(
          BigIntRange(
            BigInt.from(8),
            BigInt.from(4),
            BigIntExtension.negativeTwo,
          ),
          included: toBigIntList([8, 6]),
          excluded: toBigIntList([2, 3, 4, 5, 7, 9, 10]),
        );
        verifyRange(
          BigIntRange(
            BigInt.from(7),
            BigInt.from(2),
            BigIntExtension.negativeTwo,
          ),
          included: toBigIntList([7, 5, 3]),
          excluded: toBigIntList([1, 2, 4, 6, 8, 9]),
        );
        verifyRange(
          BigIntRange(
            BigInt.from(6),
            BigInt.from(2),
            BigIntExtension.negativeTwo,
          ),
          included: toBigIntList([6, 4]),
          excluded: toBigIntList([2, 3, 5, 7, 8, 9]),
        );
      });
      test('positive step size', () {
        for (var end = 31; end <= 40; end++) {
          verifyRange(
            BigIntRange(BigInt.from(10), BigInt.from(end), BigInt.from(10)),
            included: toBigIntList([10, 20, 30]),
            excluded: toBigIntList([5, 15, 25, 35, 40]),
          );
        }
      });
      test('negative step size', () {
        for (var end = 9; end >= 0; end--) {
          verifyRange(
            BigIntRange(BigInt.from(30), BigInt.from(end), BigInt.from(-10)),
            included: toBigIntList([30, 20, 10]),
            excluded: toBigIntList([0, 5, 15, 25, 35]),
          );
        }
      });
      test('shorthand', () {
        verifyRange(
          BigInt.zero.to(BigInt.from(3)),
          included: toBigIntList([0, 1, 2]),
          excluded: toBigIntList([-1, 3]),
        );
        verifyRange(
          BigInt.from(3).to(BigInt.zero),
          included: toBigIntList([3, 2, 1]),
          excluded: toBigIntList([4, 0]),
        );
        verifyRange(
          BigInt.two.to(BigInt.from(8), step: BigInt.two),
          included: toBigIntList([2, 4, 6]),
          excluded: toBigIntList([0, 1, 3, 5, 7, 8]),
        );
        verifyRange(
          BigInt.from(8).to(BigInt.two, step: -BigInt.two),
          included: toBigIntList([8, 6, 4]),
          excluded: toBigIntList([2, 3, 5, 7, 9]),
        );
      });
      test('stress', () {
        final random = Random(6180340);
        for (var i = 0; i < 100; i++) {
          final start = BigInt.from(random.nextInt(0xffff) - 0xffff ~/ 2);
          final end = BigInt.from(random.nextInt(0xffff) - 0xffff ~/ 2);
          final step = BigInt.from(
            start < end
                ? 1 + random.nextInt(0xfff)
                : -1 - random.nextInt(0xfff),
          );
          final expected = start < end
              ? <BigInt>[for (var j = start; j < end; j += step) j]
              : <BigInt>[for (var j = start; j > end; j += step) j];
          verifyRange(
            BigIntRange(start, end, step),
            included: expected,
            excluded: <BigInt>[],
          );
        }
      });
      test('invalid', () {
        expect(
          () => BigIntRange(BigInt.zero, BigInt.zero, BigInt.zero),
          throwsArgumentError,
        );
        expect(() => BigIntRange(null, BigInt.one), throwsArgumentError);
        expect(() => BigIntRange(null, null, BigInt.one), throwsArgumentError);
      });
      test('invalid length', () {
        final enormous = BigInt.two.pow(100);
        expect(() => BigIntRange(BigInt.zero, enormous), throwsArgumentError);
        expect(() => BigIntRange(enormous, BigInt.zero), throwsArgumentError);
        verifyRange(
          BigIntRange(enormous, enormous + BigInt.one),
          included: [enormous],
          excluded: [enormous - BigInt.one, enormous + BigInt.two],
        );
      }, testOn: '!js');
    });
    group('sublist', () {
      test('sublist (1 argument)', () {
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(0),
          included: toBigIntList([0, 1, 2]),
          excluded: toBigIntList([-1, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(1),
          included: toBigIntList([1, 2]),
          excluded: toBigIntList([-1, 0, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(2),
          included: toBigIntList([2]),
          excluded: toBigIntList([-1, 0, 1, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(3),
          included: <BigInt>[],
          excluded: toBigIntList([-1, 0, 1, 2, 3]),
        );
        expect(() => BigIntRange(BigInt.from(3)).sublist(4), throwsRangeError);
      });
      test('sublist (2 arguments)', () {
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(0, 3),
          included: toBigIntList([0, 1, 2]),
          excluded: toBigIntList([-1, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(0, 2),
          included: toBigIntList([0, 1]),
          excluded: toBigIntList([-1, 2, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(0, 1),
          included: toBigIntList([0]),
          excluded: toBigIntList([-1, 1, 2, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).sublist(0, 0),
          included: <BigInt>[],
          excluded: toBigIntList([-1, 0, 1, 2, 3]),
        );
        expect(
          () => BigIntRange(BigInt.from(3)).sublist(0, 4),
          throwsRangeError,
        );
      });
      test('getRange', () {
        verifyRange(
          BigIntRange(BigInt.from(3)).getRange(0, 3),
          included: toBigIntList([0, 1, 2]),
          excluded: toBigIntList([-1, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).getRange(0, 2),
          included: toBigIntList([0, 1]),
          excluded: toBigIntList([-1, 2, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).getRange(0, 1),
          included: toBigIntList([0]),
          excluded: toBigIntList([-1, 1, 2, 3]),
        );
        verifyRange(
          BigIntRange(BigInt.from(3)).getRange(0, 0),
          included: toBigIntList([]),
          excluded: toBigIntList([-1, 0, 1, 2, 3]),
        );
        expect(
          () => BigIntRange(BigInt.from(3)).getRange(0, 4),
          throwsRangeError,
        );
      });
    });
    test('unmodifiable', () {
      final list = BigIntRange(BigInt.one, BigInt.from(5));
      expect(() => list[0] = BigInt.from(5), throwsUnsupportedError);
      expect(() => list.first = BigInt.from(5), throwsUnsupportedError);
      expect(() => list.last = BigInt.from(5), throwsUnsupportedError);
      expect(() => list.add(BigInt.from(5)), throwsUnsupportedError);
      expect(() => list.addAll(list), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(
        () => list.fillRange(2, 4, BigInt.from(5)),
        throwsUnsupportedError,
      );
      expect(() => list.insert(2, BigInt.from(5)), throwsUnsupportedError);
      expect(() => list.insertAll(2, list), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(BigInt.one), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(() => list.replaceRange(2, 4, list), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
      expect(() => list.setAll(2, list), throwsUnsupportedError);
      expect(() => list.setRange(2, 4, list), throwsUnsupportedError);
      expect(() => list.shuffle(), throwsUnsupportedError);
      expect(() => list.sort(), throwsUnsupportedError);
    });
  });
}
