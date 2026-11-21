import 'package:checks/checks.dart';
import 'package:more/number.dart';

import '../test_utils.dart';

export '../test_utils.dart';

const epsilon = defaultEpsilon;

/// Extension on [Subject] of [Fraction] providing domain-specific checks.
extension FractionChecks on Subject<Fraction> {
  /// Extracts the numerator.
  Subject<int> get numerator => has('numerator', (f) => f.numerator);

  /// Extracts the denominator.
  Subject<int> get denominator => has('denominator', (f) => f.denominator);

  /// Asserts all standard properties of the fraction.
  void isFraction(int numerator, [int denominator = 1]) {
    has('numerator', (each) => each.numerator).equals(numerator);
    has('denominator', (each) => each.denominator).equals(denominator);
    has('isFinite', (each) => each.isFinite).equals(denominator != 0);
    has(
      'isInfinite',
      (each) => each.isInfinite,
    ).equals(numerator != 0 && denominator == 0);
    has('isNegative', (each) => each.isNegative).equals(numerator < 0);
    has(
      'isNaN',
      (each) => each.isNaN,
    ).equals(numerator == 0 && denominator == 0);
  }
}

/// Extension on [Subject] of [Complex] providing domain-specific checks.
extension ComplexChecks on Subject<Complex> {
  /// Extracts the real component `a`.
  Subject<num> get a => has('a', (c) => c.a);

  /// Extracts the imaginary component `b`.
  Subject<num> get b => has('b', (c) => c.b);

  /// Extracts the real component.
  Subject<num> get real => has('real', (c) => c.real);

  /// Extracts the imaginary component.
  Subject<num> get imaginary => has('imaginary', (c) => c.imaginary);
}

/// Extension on [Subject] of [Quaternion] providing domain-specific checks.
extension QuaternionChecks on Subject<Quaternion> {
  /// Extracts the first component `w`.
  Subject<num> get w => has('w', (q) => q.w);

  /// Extracts the second component `x`.
  Subject<num> get x => has('x', (q) => q.x);

  /// Extracts the third component `y`.
  Subject<num> get y => has('y', (q) => q.y);

  /// Extracts the fourth component `z`.
  Subject<num> get z => has('z', (q) => q.z);
}
