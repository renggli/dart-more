import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('hyperbolic', () {
    test('cosh', () {
      check(0.cosh()).isCloseTo(1);
      check(1.cosh()).isCloseTo(1.5430806348152437);
      check((-1).cosh()).isCloseTo(1.5430806348152437);
    });
    test('acosh', () {
      check((-1).acosh()).isNaN();
      check(0.acosh()).isNaN();
      check(0.5.acosh()).isNaN();
      check(1.acosh()).isCloseTo(0);
      check(2.acosh()).isCloseTo(1.3169578969248166);
    });
    test('sinh', () {
      check(0.sinh()).isCloseTo(0);
      check(1.sinh()).isCloseTo(1.1752011936438014);
    });
    test('asinh', () {
      check(1.asinh()).isCloseTo(0.881373587019543);
      check(0.asinh()).isCloseTo(0);
      check(double.negativeInfinity.asinh()).equals(double.negativeInfinity);
    });
    test('tanh', () {
      check(0.tanh()).isCloseTo(0);
      check(double.infinity.tanh()).isCloseTo(1);
      check(1.tanh()).isCloseTo(0.7615941559557649);
    });
    test('atanh', () {
      check((-2).atanh()).isNaN();
      check((-1).atanh()).equals(double.negativeInfinity);
      check(0.atanh()).isCloseTo(0);
      check(0.5.atanh()).isCloseTo(0.5493061443340548);
      check(1.atanh()).equals(double.infinity);
      check(2.atanh()).isNaN();
    });
    test('acoth', () {
      check((-2).acoth()).isCloseTo(-0.5493061443340548);
      check((-1).acoth()).equals(double.negativeInfinity);
      check(0.acoth()).isNaN();
      check(1.acoth()).equals(double.infinity);
      check(2.acoth()).isCloseTo(0.5493061443340548);
    });
    test('asech', () {
      check(1.asech()).isCloseTo(0);
      check(0.5.asech()).isCloseTo(1.3169578969248166);
      check(0.2.asech()).isCloseTo(2.2924316695611777);
      check(2.asech()).isNaN();
    });
    test('acsch', () {
      check(1.acsch()).isCloseTo(0.881373587019543);
      check((-1).acsch()).isCloseTo(-0.881373587019543);
      check(0.acsch()).equals(double.infinity);
    });
    test('coth', () {
      check(0.coth()).equals(double.infinity);
      check(1.coth()).isCloseTo(1.3130352854993312);
      check(double.infinity.coth()).isCloseTo(1);
    });
    test('sech', () {
      check(0.sech()).isCloseTo(1);
      check(1.sech()).isCloseTo(0.6480542736638855);
      check(double.infinity.sech()).isCloseTo(0);
    });
    test('csch', () {
      check(0.csch()).equals(double.infinity);
      check(1.csch()).isCloseTo(0.8509181282393216);
      check(double.infinity.csch()).isCloseTo(0);
    });
  });
}
