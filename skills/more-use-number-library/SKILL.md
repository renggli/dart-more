---
name: more-dart-use-number-library
description: "Extended numeric types in package:more/number.dart: exact rational Fraction, Complex numbers, 3D rotational Quaternion, and CloseTo approximate equality."
---

# MoreDart Number Library (`package:more/number.dart`)

Provides immutable, arithmetic-enabled value types for exact rational numbers (`Fraction`), complex numbers (`Complex`), and 3D rotational hypercomplex numbers (`Quaternion`), all supporting approximate equality via `CloseTo`.

---

## `Fraction` (Exact Rational Arithmetic)

Automatically reduces numerator and denominator to canonical lowest terms:

```dart
import 'package:more/number.dart';

// Construction: exact, rational approximation of double, or string parsing
final a = Fraction(1, 3);
final b = Fraction.fromDouble(0.75); // Fraction(3, 4)
final c = Fraction.parse('2/6'); // Fraction(1, 3)

// Arithmetic & comparisons
final sum = a + b; // Fraction(13, 12)
final product = a * b; // Fraction(1, 4)
final inv = a.reciprocal(); // Fraction(3, 1)

// Farey sequences & infinite Calkin-Wilf positive rationals
final farey3 = Fraction.farey(3); // [0/1, 1/3, 1/2, 2/3, 1/1]
final firstFivePositive = Fraction.positive.take(5).toList();
```

---

## `Complex` (Complex Numbers)

Represents $a + b i$ with Cartesian and polar constructors and transcendental functions:

```dart
final z1 = const Complex(3, 4);
final z2 = Complex.fromPolar(2, 0.5);
final parsed = Complex.parse('1-2i'); // Complex(1, -2)

// Properties & arithmetic
final magnitude = z1.abs(); // 5.0
final phase = z1.arg();
final conj = z1.conjugate(); // Complex(3, -4)
final quot = z1 / const Complex(1, 1);

// Roots, exponentials, logarithms, and trigonometry
final rootsOfUnity = Complex.one.roots(4); // [1, i, -1, -i]
final euler = (Complex.i * 3.141592653589793).exp();
final isNearMinusOne = euler.closeTo(const Complex(-1, 0), 1e-12); // true
```

---

## `Quaternion` (Hypercomplex Numbers & 3D Rotations)

Represents $w + x i + y j + z k$:

```dart
// Construction from components, axis-angle, Euler angles, or vector rotation
final q1 = const Quaternion(1, 2, 3, 4);
final rotZ = Quaternion.fromAxis(const [0, 0, 1], 1.5707963267948966);
final fromVecs = Quaternion.fromVectors(const [1, 0, 0], const [0, 1, 0]);
final qParsed = Quaternion.parse('1+2i-3j+4k');

// Operations
final unit = q1.normalize();
final inverse = q1.reciprocal();
final identityCheck = (q1 * inverse).closeTo(Quaternion.one, 1e-9); // true
```
