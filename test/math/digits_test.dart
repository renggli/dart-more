import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('digits', () {
    group('base 10', () {
      test('int', () {
        check(0.digits()).deepEquals([0]);
        check(1.digits()).deepEquals([1]);
        check(12.digits()).deepEquals([2, 1]);
        check(123.digits()).deepEquals([3, 2, 1]);
        check(1001.digits()).deepEquals([1, 0, 0, 1]);
        check(10001.digits()).deepEquals([1, 0, 0, 0, 1]);
        check(1000.digits()).deepEquals([0, 0, 0, 1]);
        check(10000.digits()).deepEquals([0, 0, 0, 0, 1]);
      });
      test('BigInt', () {
        check(BigInt.from(0).digits()).deepEquals([0]);
        check(BigInt.from(1).digits()).deepEquals([1]);
        check(BigInt.from(12).digits()).deepEquals([2, 1]);
        check(BigInt.from(123).digits()).deepEquals([3, 2, 1]);
        check(BigInt.from(1001).digits()).deepEquals([1, 0, 0, 1]);
        check(BigInt.from(10001).digits()).deepEquals([1, 0, 0, 0, 1]);
        check(BigInt.from(1000).digits()).deepEquals([0, 0, 0, 1]);
        check(BigInt.from(10000).digits()).deepEquals([0, 0, 0, 0, 1]);
      });
    });
    group('base 2', () {
      test('int', () {
        check(0.digits(2)).deepEquals([0]);
        check(1.digits(2)).deepEquals([1]);
        check(12.digits(2)).deepEquals([0, 0, 1, 1]);
        check(123.digits(2)).deepEquals([1, 1, 0, 1, 1, 1, 1]);
        check(1001.digits(2)).deepEquals([1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        check(10001.digits(2))
            .deepEquals([1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
        check(1000.digits(2)).deepEquals([0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        check(10000.digits(2))
            .deepEquals([0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      });
      test('BigInt', () {
        check(BigInt.from(0).digits(2)).deepEquals([0]);
        check(BigInt.from(1).digits(2)).deepEquals([1]);
        check(BigInt.from(12).digits(2)).deepEquals([0, 0, 1, 1]);
        check(BigInt.from(123).digits(2)).deepEquals([1, 1, 0, 1, 1, 1, 1]);
        check(BigInt.from(1001).digits(2))
            .deepEquals([1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        check(BigInt.from(10001).digits(2))
            .deepEquals([1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
        check(BigInt.from(1000).digits(2))
            .deepEquals([0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        check(BigInt.from(10000).digits(2))
            .deepEquals([0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      });
    });
    group('base 16', () {
      test('int', () {
        check(0.digits(16)).deepEquals([0]);
        check(1.digits(16)).deepEquals([1]);
        check(12.digits(16)).deepEquals([12]);
        check(123.digits(16)).deepEquals([11, 7]);
        check(1001.digits(16)).deepEquals([9, 14, 3]);
        check(10001.digits(16)).deepEquals([1, 1, 7, 2]);
        check(1000.digits(16)).deepEquals([8, 14, 3]);
        check(10000.digits(16)).deepEquals([0, 1, 7, 2]);
      });
      test('BigInt', () {
        check(BigInt.from(0).digits(16)).deepEquals([0]);
        check(BigInt.from(1).digits(16)).deepEquals([1]);
        check(BigInt.from(12).digits(16)).deepEquals([12]);
        check(BigInt.from(123).digits(16)).deepEquals([11, 7]);
        check(BigInt.from(1001).digits(16)).deepEquals([9, 14, 3]);
        check(BigInt.from(10001).digits(16)).deepEquals([1, 1, 7, 2]);
        check(BigInt.from(1000).digits(16)).deepEquals([8, 14, 3]);
        check(BigInt.from(10000).digits(16)).deepEquals([0, 1, 7, 2]);
      });
    });
    group('negative', () {
      test('int', () {
        check((-0).digits()).deepEquals([0]);
        check((-1).digits()).deepEquals([1]);
        check((-12).digits()).deepEquals([2, 1]);
        check((-123).digits()).deepEquals([3, 2, 1]);
      });
      test('BigInt', () {
        check(BigInt.from(-0).digits()).deepEquals([0]);
        check(BigInt.from(-1).digits()).deepEquals([1]);
        check(BigInt.from(-12).digits()).deepEquals([2, 1]);
        check(BigInt.from(-123).digits()).deepEquals([3, 2, 1]);
      });
    });
  });
}
