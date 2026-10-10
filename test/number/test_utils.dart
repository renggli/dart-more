import 'package:checks/checks.dart';
import 'package:more/number.dart';

import '../test_utils.dart';

export '../test_utils.dart';

const epsilon = defaultEpsilon;

/// Extension on [Subject] of [Fraction] providing domain-specific checks.
extension FractionChecks on Subject<Fraction> {
  /// Extracts the numerator.
  Subject<int> get numerator => has((f) => f.numerator, 'numerator');

  /// Extracts the denominator.
  Subject<int> get denominator => has((f) => f.denominator, 'denominator');

  /// Asserts all standard properties of the fraction.
  void isFraction(int numerator, [int denominator = 1]) {
    has((each) => each.numerator, 'numerator').equals(numerator);
    has((each) => each.denominator, 'denominator').equals(denominator);
    has((each) => each.isFinite, 'isFinite').equals(denominator != 0);
    has(
      (each) => each.isInfinite,
      'isInfinite',
    ).equals(numerator != 0 && denominator == 0);
    has((each) => each.isNegative, 'isNegative').equals(numerator < 0);
    has(
      (each) => each.isNaN,
      'isNaN',
    ).equals(numerator == 0 && denominator == 0);
  }
}

/// Extension on [Subject] of [Complex] providing domain-specific checks.
extension ComplexChecks on Subject<Complex> {
  /// Extracts the real component `a`.
  Subject<num> get a => has((c) => c.a, 'a');

  /// Extracts the imaginary component `b`.
  Subject<num> get b => has((c) => c.b, 'b');

  /// Extracts the real component.
  Subject<num> get real => has((c) => c.real, 'real');

  /// Extracts the imaginary component.
  Subject<num> get imaginary => has((c) => c.imaginary, 'imaginary');
}

/// Extension on [Subject] of [Quaternion] providing domain-specific checks.
extension QuaternionChecks on Subject<Quaternion> {
  /// Extracts the first component `w`.
  Subject<num> get w => has((q) => q.w, 'w');

  /// Extracts the second component `x`.
  Subject<num> get x => has((q) => q.x, 'x');

  /// Extracts the third component `y`.
  Subject<num> get y => has((q) => q.y, 'y');

  /// Extracts the fourth component `z`.
  Subject<num> get z => has((q) => q.z, 'z');
}
