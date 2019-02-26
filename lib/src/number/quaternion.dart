library more.number.quaternion;

import 'dart:math' as math;

import 'package:more/hash.dart' show hash4;

/// A quaternion number of the form `w + x*i + y*j + z*k`.
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
  const Quaternion(this.w, [this.x = 0, this.y = 0, this.z = 0])
      : assert(w != null),
        assert(x != null),
        assert(y != null),
        assert(z != null);

  /// Constructors a quaternion from a scalar and a vector.
  factory Quaternion.of(num scalar, List<num> vector) =>
      Quaternion(scalar, vector[0], vector[1], vector[2]);

  /// Constructors a quaternion from a vector.
  factory Quaternion.fromList(List<num> vector) =>
      Quaternion(vector[0], vector[1], vector[2], vector[3]);

  /// Constructs a quaternion from an [axis] and a rotation [angle].
  factory Quaternion.fromAxis(List<num> axis, num angle) {
    final norm = math.sin(0.5 * angle) /
        math.sqrt(axis[0] * axis[0] + axis[1] * axis[1] + axis[2] * axis[2]);
    return Quaternion(
        math.cos(0.5 * angle), axis[0] * norm, axis[1] * norm, axis[2] * norm);
  }

  /// Constructs a quaternion from the rotation between two vectors [source]
  /// and [target].
  factory Quaternion.fromVectors(List<num> source, List<num> target) {
    final w =
        source[0] * target[0] + source[1] * target[1] + source[2] * target[2];
    final x = source[1] * target[2] - source[2] * target[1];
    final y = source[2] * target[0] - source[0] * target[2];
    final z = source[0] * target[1] - source[1] * target[0];
    return Quaternion(w + math.sqrt(w * w + x * x + y * y + z * z), x, y, z)
        .normalize();
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
    num w = 0, x = 0, y = 0, z = 0;
    final seen = <String>{};
    for (var part in parts) {
      final number = num.tryParse(part.group(1));
      final unit = part.group(4).toLowerCase();
      if (seen.contains(unit)) {
        return null; // repeated unit
      }
      if (unit == '' && number != null) {
        w = number;
      } else if (part.group(1).isEmpty || number != null) {
        switch (unit) {
          case 'i':
            x = number ?? 1;
            break;
          case 'j':
            y = number ?? 1;
            break;
          case 'k':
            z = number ?? 1;
            break;
          default:
            return null; // invalid unit
        }
      } else {
        return null; // parse error
      }
      seen.add(unit);
    }
    return Quaternion(w, x, y, z);
  }

  /// The 1st quaternion unit (scalar part).
  final num w;

  /// The 2nd quaternion unit (1st vector/imaginary part).
  final num x;

  /// The 3rd quaternion unit (2nd vector/imaginary part).
  final num y;

  /// The 4th quaternion unit (3rd vector/imaginary part).
  final num z;

  /// Returns the absolute value of the quaternion.
  double abs() => math.sqrt(norm());

  /// Returns the squared absolute value.
  num norm() => w * w + x * x + y * y + z * z;

  /// Returns the negated form of the quaternion.
  Quaternion operator -() => Quaternion(-w, -x, -y, -z);

  /// Returns the conjugate form of the quaternion.
  Quaternion conjugate() => Quaternion(w, -x, -y, -z);

  /// Returns the normalized form of the quarternion.
  Quaternion normalize() {
    final f = 1 / abs();
    return Quaternion(w * f, x * f, y * f, z * f);
  }

  /// Returns the sum of this number and another one.
  Quaternion operator +(Object other) {
    if (other is Quaternion) {
      return Quaternion(w + other.w, x + other.x, y + other.y, z + other.z);
    } else if (other is num) {
      return Quaternion(w + other, x, y, z);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the difference of this number and another one.
  Quaternion operator -(Object other) {
    if (other is Quaternion) {
      return Quaternion(w - other.w, x - other.x, y - other.y, z - other.z);
    } else if (other is num) {
      return Quaternion(w - other, x, y, z);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Returns the product of this number and another one.
  Quaternion operator *(Object other) {
    if (other is Quaternion) {
      return Quaternion(
        w * other.w - x * other.x - y * other.y - z * other.z,
        w * other.x + x * other.w + y * other.z - z * other.y,
        w * other.y + y * other.w + z * other.x - x * other.z,
        w * other.z + z * other.w + x * other.y - y * other.x,
      );
    } else if (other is num) {
      return Quaternion(w * other, x * other, y * other, z * other);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Computes the multiplicative inverse of this quaternion.
  Quaternion reciprocal() {
    final f = 1 / norm();
    return Quaternion(w * f, -x * f, -y * f, -z * f);
  }

  /// Computes the division of this number and another one.
  Quaternion operator /(Object other) {
    if (other is Quaternion) {
      final f = 1 / norm();
      return Quaternion(
        (w * other.w + x * other.x + y * other.y + z * other.z) * f,
        (x * other.w - w * other.x - y * other.z + z * other.y) * f,
        (y * other.w - w * other.y - z * other.x + x * other.z) * f,
        (z * other.w - w * other.z - x * other.y + y * other.x) * f,
      );
    } else if (other is num) {
      return Quaternion(w / other, x / other, y / other, z / other);
    } else {
      throw ArgumentError.value(other);
    }
  }

  /// Computes the exponential function of this quaternion number.
  Quaternion exp() {
    final exp = math.exp(w);
    final norm = math.sqrt(x * x + y * y + z * z);
    final scale = exp / norm * math.sin(norm);
    return Quaternion(exp * math.cos(norm), x * scale, y * scale, z * scale);
  }

  /// Computes the natural logarithm of this quaternion number.
  Quaternion log() {
    final vectorNorm = math.sqrt(x * x + y * y + z * z);
    final scale = math.atan2(vectorNorm, w) / vectorNorm;
    return Quaternion(0.5 * math.log(norm()), x * scale, y * scale, z * scale);
  }

  /// Computes the power of this quaternion number raised to `exponent`.
  Quaternion pow(Object exponent) => (log() * exponent).exp();

  /// Tests if this complex number is not defined.
  bool get isNaN => w.isNaN || x.isNaN || y.isNaN || z.isNaN;

  /// Tests if this complex number is infinite.
  bool get isInfinite =>
      w.isInfinite || x.isInfinite || y.isInfinite || z.isInfinite;

  /// Rounds the values of this complex number to integers.
  Quaternion round() => Quaternion(w.round(), x.round(), y.round(), z.round());

  /// Floors the values of this complex number to integers.
  Quaternion floor() => Quaternion(w.floor(), x.floor(), y.floor(), z.floor());

  /// Ceils the values of this complex number to integers.
  Quaternion ceil() => Quaternion(w.ceil(), x.ceil(), y.ceil(), z.ceil());

  /// Truncates the values of this complex number to integers.
  Quaternion truncate() =>
      Quaternion(w.truncate(), x.truncate(), y.truncate(), z.truncate());

  /// Tests if this complex number is close to another complex number.
  bool closeTo(Quaternion other, double epsilon) =>
      (this - other).abs() < epsilon;

  @override
  bool operator ==(Object other) =>
      other is Quaternion &&
      w == other.w &&
      x == other.x &&
      y == other.y &&
      z == other.z;

  @override
  int get hashCode => hash4(w, x, y, z);

  @override
  String toString() => 'Quaternion($w, $x, $y, $z)';
}

final RegExp numberAndUnitExtractor =
    RegExp(r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)\*?(\w?)', caseSensitive: false);
