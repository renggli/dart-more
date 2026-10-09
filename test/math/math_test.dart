import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('math', () {
    test('pow(x, 0)', () {
      check((-2).pow(0)).equals(1);
      check((-1).pow(0)).equals(1);
      check(0.pow(0)).equals(1);
      check(1.pow(0)).equals(1);
      check(2.pow(0)).equals(1);
    });
    test('pow(x, 1)', () {
      check((-2).pow(1)).equals(-2);
      check((-1).pow(1)).equals(-1);
      check(0.pow(1)).equals(0);
      check(1.pow(1)).equals(1);
      check(2.pow(1)).equals(2);
    });
    test('pow(x, 5)', () {
      check((-2).pow(5)).equals(-32);
      check((-1).pow(5)).equals(-1);
      check(0.pow(5)).equals(0);
      check(1.pow(5)).equals(1);
      check(2.pow(5)).equals(32);
    });
    test('pow(x, -2)', () {
      check((-2).pow(-2)).equals(0.25);
      check((-1).pow(-2)).equals(1.0);
      check(1.pow(-2)).equals(1.0);
      check(2.pow(-2)).equals(0.25);
    });
    test('sin', () {
      check(0.sin()).isCloseTo(0);
      check((0.5 * math.pi).sin()).isCloseTo(1);
      check(math.pi.sin()).isCloseTo(0);
    });
    test('asin', () {
      check(1.asin()).isCloseTo(1.5707963267948966);
      check((-1).asin()).isCloseTo(-1.5707963267948966);
    });
    test('cos', () {
      check(0.cos()).isCloseTo(1);
      check((0.5 * math.pi).cos()).isCloseTo(0);
      check(math.pi.cos()).isCloseTo(-1);
    });
    test('acos', () {
      check(1.acos()).isCloseTo(0);
      check((-1).acos()).isCloseTo(math.pi);
    });
    test('tan', () {
      check(0.tan()).isCloseTo(0);
      check(1.tan()).isCloseTo(1.55740772465);
    });
    test('atan', () {
      check(1.atan()).isCloseTo(0.7853981633974483);
      check((-1).atan()).isCloseTo(-0.7853981633974483);
    });
    test('atan2', () {
      check(1.atan2(2)).isCloseTo(0.4636476090008061);
      check(2.atan2(1)).isCloseTo(1.1071487177940904);
    });
    test('sqrt', () {
      check(2.sqrt()).isCloseTo(1.4142135623730951);
      check(3.sqrt()).isCloseTo(1.7320508075688772);
      check(4.sqrt()).isCloseTo(2.00);
    });
    test('toDegrees', () {
      check(0.toDegrees()).isCloseTo(0);
      check((math.pi / 2).toDegrees()).isCloseTo(90);
      check(math.pi.toDegrees()).isCloseTo(180);
      check(1.toDegrees()).isCloseTo(57.29577951308232);
    });
    test('toRadians', () {
      check(0.toRadians()).isCloseTo(0);
      check(90.toRadians()).isCloseTo(math.pi / 2);
      check(180.toRadians()).isCloseTo(math.pi);
      check(57.29577951308232.toRadians()).isCloseTo(1);
    });
    test('exp', () {
      check(0.exp()).isCloseTo(1);
      check(1.exp()).isCloseTo(math.e);
      check((-1).exp()).isCloseTo(1 / math.e);
    });
    test('log', () {
      check(1.log()).isCloseTo(0);
      check(math.e.log()).isCloseTo(1);
      check((1 / math.e).log()).isCloseTo(-1);
    });
    test('between', () {
      check(2.between(1, 3)).isTrue();
      check(2.between(2, 3)).isTrue();
      check(2.between(1, 2)).isTrue();
      check(2.between(0, 1)).isFalse();
      check(2.between(3, 4)).isFalse();
    });
    test('clip', () {
      check((-2).clip(-1, 1)).equals(-1);
      check((-1).clip(-1, 1)).equals(-1);
      check(0.clip(-1, 1)).equals(0);
      check(1.clip(-1, 1)).equals(1);
      check(2.clip(-1, 1)).equals(1);
    });
  });
}
