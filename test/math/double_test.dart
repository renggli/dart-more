import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('double', () {
    group('nextDown', () {
      double nextDown(double value) {
        final result = value.nextDown;
        if (value.isNaN) {
          check(result).isNaN();
        } else if (value == double.negativeInfinity) {
          check(result).equals(double.negativeInfinity);
        } else {
          check(result).isLessThan(value);
          check(result.nextUp).equals(value);
        }
        return result;
      }

      test('basic', () {
        check(nextDown(-1.0)).equals(-1.0000000000000002);
        check(nextDown(1.0)).equals(0.9999999999999999);
      });
      test('special', () {
        check(nextDown(double.nan)).isNaN();
        check(nextDown(double.infinity)).equals(double.maxFinite);
        check(nextDown(double.negativeInfinity))
            .equals(double.negativeInfinity);
        check(nextDown(-double.maxFinite)).equals(double.negativeInfinity);
        check(nextDown(double.minPositive)).equals(0.0);
        check(nextDown(0.0)).equals(-double.minPositive);
      });
      test('stress', () {
        final random = Random(4678);
        for (var i = 0; i < 1000; i++) {
          nextDown(
            2 * (random.nextDouble() - 0.5) * pow(10, random.nextInt(51) - 25),
          );
        }
      });
    });
    group('nextUp', () {
      double nextUp(double value) {
        final result = value.nextUp;
        if (value.isNaN) {
          check(result).isNaN();
        } else if (value == double.infinity) {
          check(result).equals(double.infinity);
        } else {
          check(result).isGreaterThan(value);
          check(result.nextDown).equals(value);
        }
        return result;
      }

      test('basic', () {
        check(nextUp(-1.0)).equals(-0.9999999999999999);
        check(nextUp(1.0)).equals(1.0000000000000002);
      });
      test('special', () {
        check(nextUp(double.nan)).isNaN();
        check(nextUp(double.infinity)).equals(double.infinity);
        check(nextUp(double.negativeInfinity)).equals(-double.maxFinite);
        check(nextUp(double.maxFinite)).equals(double.infinity);
        check(nextUp(-double.minPositive)).equals(0.0);
        check(nextUp(0.0)).equals(double.minPositive);
      });
      test('stress', () {
        final random = Random(8913);
        for (var i = 0; i < 1000; i++) {
          nextUp(
            2 * (random.nextDouble() - 0.5) * pow(10, random.nextInt(51) - 25),
          );
        }
      });
    });
    group('ulp', () {
      double ulp(double value) {
        final result = value.ulp;
        if (value.isNaN) {
          check(result).isNaN();
        } else {
          check(result).isGreaterThan(0);
          check((-value).ulp).equals(result);
        }
        return result;
      }

      test('basic', () {
        check(ulp(1e-52)).equals(1.8546030753437107e-68);
        check(ulp(1e-25)).equals(1.1479437019748901e-41);
        check(ulp(1e-10)).equals(1.2924697071141057e-26);
        check(ulp(0.25)).equals(5.551115123125783e-17);
        check(ulp(0.5)).equals(1.1102230246251565e-16);
        check(ulp(0.6)).equals(1.1102230246251565e-16);
        check(ulp(1)).equals(2.220446049250313e-16);
        check(ulp(1e10)).equals(0.0000019073486328125);
        check(ulp(1e25)).equals(2147483648.0);
        check(ulp(1e52)).equals(1.329227995784916e+36);
      });
      test('special', () {
        check(ulp(0.0)).equals(double.minPositive);
        check(ulp(double.nan)).isNaN();
        check(ulp(double.infinity)).equals(double.infinity);
        check(ulp(double.negativeInfinity)).equals(double.infinity);
      });
    });
    group('nextTowards', () {
      test('basic', () {
        check(-1.0.nextTowards(0.0)).equals(-0.9999999999999999);
        check(1.0.nextTowards(0.0)).equals(0.9999999999999999);
      });
      test('special', () {
        check(double.nan.nextTowards(0.0)).isNaN();
        check(double.infinity.nextTowards(0.0)).equals(double.maxFinite);
        check(double.negativeInfinity.nextTowards(0.0))
            .equals(-double.maxFinite);
        check(0.0.nextTowards(0.0)).equals(0.0);
      });
      test('stress', () {
        final random = Random(8913);
        for (var i = 0; i < 1000; i++) {
          final value =
              2 *
              (random.nextDouble() - 0.5) *
              pow(10, random.nextInt(51) - 25);
          final result = value.nextTowards(0.0);
          if (value < 0.0) {
            check(result).equals(value.nextUp);
          } else if (value > 0.0) {
            check(result).equals(value.nextDown);
          } else {
            check(result).equals(0.0);
          }
        }
      });
    });
  });
}
