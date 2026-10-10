import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

import 'range_test_utils.dart';

void main() {
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
    test('default', () {
      verifyRange(
        BigIntRange(),
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
          start < end ? 1 + random.nextInt(0xfff) : -1 - random.nextInt(0xfff),
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
      check(() => BigIntRange(BigInt.zero, BigInt.zero, BigInt.zero))
          .throws<ArgumentError>();
      check(() => BigIntRange(null, BigInt.one)).throws<ArgumentError>();
      check(() => BigIntRange(null, null, BigInt.one)).throws<ArgumentError>();
    });
    test('invalid length', () {
      final enormous = BigInt.two.pow(100);
      check(() => BigIntRange(BigInt.zero, enormous)).throws<ArgumentError>();
      check(() => BigIntRange(enormous, BigInt.zero)).throws<ArgumentError>();
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
      check(() => BigIntRange(BigInt.from(3)).sublist(4)).throws<RangeError>();
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
      check(() => BigIntRange(BigInt.from(3)).sublist(0, 4))
          .throws<RangeError>();
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
      check(() => BigIntRange(BigInt.from(3)).getRange(0, 4))
          .throws<RangeError>();
    });
  });
  test('unmodifiable', () {
    final list = BigIntRange(BigInt.one, BigInt.from(5));
    check(() => list[0] = BigInt.from(5)).throws<UnsupportedError>();
    check(() => list.first = BigInt.from(5)).throws<UnsupportedError>();
    check(() => list.last = BigInt.from(5)).throws<UnsupportedError>();
    check(() => list.add(BigInt.from(5))).throws<UnsupportedError>();
    check(() => list.addAll(list)).throws<UnsupportedError>();
    check(list.clear).throws<UnsupportedError>();
    check(() => list.fillRange(2, 4, BigInt.from(5)))
        .throws<UnsupportedError>();
    check(() => list.insert(2, BigInt.from(5))).throws<UnsupportedError>();
    check(() => list.insertAll(2, list)).throws<UnsupportedError>();
    check(() => list.length = 10).throws<UnsupportedError>();
    check(() => list.remove(BigInt.one)).throws<UnsupportedError>();
    check(() => list.removeAt(2)).throws<UnsupportedError>();
    check(list.removeLast).throws<UnsupportedError>();
    check(() => list.removeRange(2, 4)).throws<UnsupportedError>();
    check(() => list.removeWhere((value) => true)).throws<UnsupportedError>();
    check(() => list.replaceRange(2, 4, list)).throws<UnsupportedError>();
    check(() => list.retainWhere((value) => false)).throws<UnsupportedError>();
    check(() => list.setAll(2, list)).throws<UnsupportedError>();
    check(() => list.setRange(2, 4, list)).throws<UnsupportedError>();
    check(list.shuffle).throws<UnsupportedError>();
    check(list.sort).throws<UnsupportedError>();
  });
}
