library more.number.quaternion;

import 'dart:math' as math;

/// A quaternion number of the form `a + b*i + c*j + d*k`.
class Quaternion {
  /// The neutral additive element, that is `0`.
  static const Quaternion zero = Quaternion(0);

  /// The neutral multiplicative element, that is `1`.
  static const Quaternion one = Quaternion(1);

  /// The quaternion `i` unit.
  static const Quaternion i = Quaternion(0, 1);

  /// The quaternion `j` unit.
  static const Quaternion j = Quaternion(0, 0, 1);

  /// The quaternion `k` unit.
  static const Quaternion k = Quaternion(0, 0, 0, 1);

  /// Constructs a quaternion from its components.
  const Quaternion(this.a, [this.b = 0, this.c = 0, this.d = 0])
      : assert(a != null),
        assert(b != null),
        assert(c != null),
        assert(d != null);

  /// Constructs a quaternion from an [axis] and a rotation [angle].
  factory Quaternion.fromAxis(List<num> axis, num angle) {
    final norm = math.sin(0.5 * angle) /
        math.sqrt(axis[0] * axis[0] + axis[1] * axis[1] + axis[2] * axis[2]);
    return Quaternion(
      math.cos(0.5 * angle),
      axis[0] * norm,
      axis[1] * norm,
      axis[2] * norm,
    );
  }

  /// Constructs a quaternion from the rotation between two vectors [source]
  /// and [target].
  factory Quaternion.fromVectors(List<num> source, List<num> target) {
    final a =
        source[0] * target[0] + source[1] * target[1] + source[2] * target[2];
    final b = source[1] * target[2] - source[2] * target[1];
    final c = source[2] * target[0] - source[0] * target[2];
    final d = source[0] * target[1] - source[1] * target[0];
    return Quaternion(
      a + math.sqrt(a * a + b * b + c * c + d * d),
      b,
      c,
      d,
    ).normalize();
  }

  /// Constructs a quaternion from an euler rotation.
  factory Quaternion.fromEuler(num phi, num theta, num psi) {
    final halfPhi = phi * 0.5;
    final halfTheta = theta * 0.5;
    final halfPsi = psi * 0.5;

    final cosPhi = math.cos(halfPhi);
    final cosTheta = math.cos(halfTheta);
    final cosPsi = math.cos(halfPsi);

    final sinPhi = math.sin(halfPhi);
    final sinTheta = math.sin(halfTheta);
    final sinPsi = math.sin(halfPsi);

    return Quaternion(
      cosTheta * cosPsi * cosPhi - sinTheta * sinPsi * sinPhi,
      sinTheta * cosPsi * cosPhi - cosTheta * sinPsi * sinPhi,
      cosTheta * sinPsi * cosPhi + sinTheta * cosPsi * sinPhi,
      cosTheta * cosPsi * sinPhi + sinTheta * sinPsi * cosPhi,
    );
  }

  /// Parses [source] as a [Quaternion]. Returns `null` in case of a problem.
  factory Quaternion.tryParse(String source) {
    final parts = numberAndUnitExtractor
        .allMatches(source.replaceAll(' ', ''))
        .where((match) => match.start < match.end)
        .toList();
    if (parts.isEmpty) {
      return null;
    }
    num a = 0, b = 0, c = 0, d = 0;
    final seen = Set();
    for (var part in parts) {
      final number = num.tryParse(part.group(1));
      final unit = part.group(4).toLowerCase();
      if (seen.contains(unit)) {
        return null; // repeated unit
      }
      if (unit == '' && number != null) {
        a = number;
      } else if (part.group(1).isEmpty || number != null) {
        switch (unit) {
          case 'i':
            b = number ?? 1;
            break;
          case 'j':
            c = number ?? 1;
            break;
          case 'k':
            d = number ?? 1;
            break;
          default:
            return null; // invalid unit
        }
      } else {
        return null; // parse error
      }
      seen.add(unit);
    }
    return Quaternion(a, b, c, d);
  }

  /// The 1st quaternion unit (scalar part).
  final num a;

  /// The 2nd quaternion unit (1st vector/imaginary part).
  final num b;

  /// The 3rd quaternion unit (2nd vector/imaginary part).
  final num c;

  /// The 4th quaternion unit (3rd vector/imaginary part).
  final num d;

  /// Returns the absolute value (or norm) of the quaternion.
  double abs() => math.sqrt(a * a + b * b + c * c + d * d);

  /// Returns the negated form of the quaternion.
  Quaternion operator -() => Quaternion(-a, -b, -c, -d);

  /// Returns the conjugate form of the quaternion.
  Quaternion conjugate() => Quaternion(a, -b, -c, -d);

  /// Returns the normalized form of the quarternion.
  Quaternion normalize() {
    final factor = 1.0 / math.sqrt(a * a + b * b + c * c + d * d);
    return Quaternion(a * factor, b * factor, c * factor, d * factor);
  }

  /// Returns the sum of this number and another one.
  Quaternion operator +(Quaternion other) => Quaternion(
        a + other.a,
        b + other.b,
        c + other.c,
        d + other.d,
      );

  /// Returns the difference of this number and another one.
  Quaternion operator -(Quaternion other) => Quaternion(
        a - other.a,
        b - other.b,
        c - other.c,
        d - other.d,
      );

  /// Returns the product of this number and another one.
  Quaternion operator *(Quaternion other) => Quaternion(
        a * other.a - b * other.b - c * other.c - d * other.d,
        a * other.b + b * other.a + c * other.d - d * other.c,
        a * other.c + c * other.a + d * other.b - b * other.d,
        a * other.d + d * other.a + b * other.c - c * other.b,
      );

  /// Compute the multiplicative inverse of this quaternion.
  Quaternion reciprocal() {
    final factor = 1.0 / (a * a + b * b + c * c + d * d);
    return Quaternion(a * factor, -b * factor, -c * factor, -d * factor);
  }

  /// Compute the division of this number and another one.
  Quaternion operator /(Quaternion other) {
    final factor = 1.0 / (a * a + b * b + c * c + d * d);
    return Quaternion(
      (a * other.a + b * other.b + c * other.c + d * other.d) * factor,
      (b * other.a - a * other.b - c * other.d + d * other.c) * factor,
      (c * other.a - a * other.c - d * other.b + b * other.d) * factor,
      (d * other.a - a * other.d - b * other.c + c * other.b) * factor,
    );
  }

  /// Compute the exponential function of this quaternion number.
  Quaternion exp() {
    final exp = math.exp(a);
    final norm = math.sqrt(b * b + c * c + d * d);
    final scale = exp / norm * math.sin(norm);
    return Quaternion(exp * math.cos(norm), b * scale, c * scale, d * scale);
  }

  /// Compute the natural logarithm of this quaternion number.
  Quaternion log() {
    final norm = math.sqrt(b * b + c * c + d * d);
    final norm2 = a * a + b * b + c * c + d * d;
    final scale = math.atan2(norm, a) / norm;
    return Quaternion(0.5 * math.log(norm2), b * scale, c * scale, d * scale);
  }

  /// Compute the power of this quaternion number raised to `exponent`.
  Quaternion pow(Quaternion exponent) => (log() * exponent).exp();

  /// Tests if this complex number is not defined.
  bool get isNaN => a.isNaN || b.isNaN || c.isNaN || d.isNaN;

  /// Tests if this complex number is infinite.
  bool get isInfinite =>
      a.isInfinite || b.isInfinite || c.isInfinite || d.isInfinite;

  /// Rounds the values of this complex number to integers.
  Quaternion round() => Quaternion(a.round(), b.round(), c.round(), d.round());

  /// Floors the values of this complex number to integers.
  Quaternion floor() => Quaternion(a.floor(), b.floor(), c.floor(), d.floor());

  /// Ceils the values of this complex number to integers.
  Quaternion ceil() => Quaternion(a.ceil(), b.ceil(), c.ceil(), d.ceil());

  /// Truncates the values of this complex number to integers.
  Quaternion truncate() =>
      Quaternion(a.truncate(), b.truncate(), c.truncate(), d.truncate());

  /// Tests if this complex number is close to another complex number.
  bool closeTo(Quaternion other, double epsilon) =>
      (this - other).abs() < epsilon;

  @override
  bool operator ==(Object other) =>
      other is Quaternion &&
      a == other.a &&
      b == other.b &&
      c == other.c &&
      d == other.d;

  @override
  int get hashCode =>
      (0x0007ffff & a.hashCode) << 9 ^
      (0x0007ffff & b.hashCode) << 6 ^
      (0x0007ffff & c.hashCode) << 3 ^
      d.hashCode;

  @override
  String toString() => 'Quaternion($a, $b, $c, $d)';
}

final RegExp numberAndUnitExtractor =
    RegExp(r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)\*?(\w?)', caseSensitive: false);
