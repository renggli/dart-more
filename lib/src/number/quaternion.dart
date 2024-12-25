import 'package:meta/meta.dart' show immutable;

import '../../math.dart';
import 'mixins/close_to.dart';

/// A quaternion number of the form `w + x*i + y*j + z*k`.
@immutable
class Quaternion implements CloseTo<Quaternion> {
  /// Constructs a quaternion from its components.
  const Quaternion(this.w, [this.x = 0, this.y = 0, this.z = 0]);

  /// Constructors a quaternion from a scalar and a vector.
  factory Quaternion.of(num scalar, List<num> vector) =>
      Quaternion(scalar, vector[0], vector[1], vector[2]);

  /// Constructors a quaternion from a vector.
  factory Quaternion.fromList(List<num> vector) =>
      Quaternion(vector[0], vector[1], vector[2], vector[3]);

  /// Constructs a quaternion from an [axis] and a rotation [angle].
  factory Quaternion.fromAxis(List<num> axis, num angle) {
    final halfAngle = 0.5 * angle;
    final norm = halfAngle.sin() /
        (axis[0] * axis[0] + axis[1] * axis[1] + axis[2] * axis[2]).sqrt();
    return Quaternion(
        halfAngle.cos(), axis[0] * norm, axis[1] * norm, axis[2] * norm);
  }

  /// Constructs a quaternion from the rotation between two vectors [source]
  /// and [target].
  factory Quaternion.fromVectors(List<num> source, List<num> target) {
    final w =
        source[0] * target[0] + source[1] * target[1] + source[2] * target[2];
    final x = source[1] * target[2] - source[2] * target[1];
    final y = source[2] * target[0] - source[0] * target[2];
    final z = source[0] * target[1] - source[1] * target[0];
    return Quaternion(w + (w * w + x * x + y * y + z * z).sqrt(), x, y, z)
        .normalize();
  }

  /// Constructs a quaternion from an euler rotation.
  factory Quaternion.fromEuler(num phi, num theta, num psi) {
    final halfPhi = phi * 0.5;
    final halfTheta = theta * 0.5;
    final halfPsi = psi * 0.5;

    final cosPhi = halfPhi.cos();
    final cosTheta = halfTheta.cos();
    final cosPsi = halfPsi.cos();

    final sinPhi = halfPhi.sin();
    final sinTheta = halfTheta.sin();
    final sinPsi = halfPsi.sin();

    return Quaternion(
      cosTheta * cosPsi * cosPhi - sinTheta * sinPsi * sinPhi,
      sinTheta * cosPsi * cosPhi - cosTheta * sinPsi * sinPhi,
      cosTheta * sinPsi * cosPhi + sinTheta * cosPsi * sinPhi,
      cosTheta * cosPsi * sinPhi + sinTheta * sinPsi * cosPhi,
    );
  }

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

  /// The quaternion number with all parts being [double.nan].
  static const Quaternion nan =
      Quaternion(double.nan, double.nan, double.nan, double.nan);

  /// The quaternion number with all parts being [double.infinity].
  static const Quaternion infinity = Quaternion(
      double.infinity, double.infinity, double.infinity, double.infinity);

  /// Parses [source] as a [Quaternion]. Returns `null` in case of a problem.
  static Quaternion? tryParse(String source) {
    final parts = numberAndUnitExtractor
        .allMatches(source.replaceAll(' ', ''))
        .where((match) => match.start < match.end)
        .toList();
    if (parts.isEmpty) {
      return null;
    }
    num w = 0, x = 0, y = 0, z = 0;
    final seen = <String>{};
    for (final part in parts) {
      final numberString = part.group(1) ?? '';
      final number = num.tryParse(numberString);
      final unitString = part.group(4) ?? '';
      final unit = unitString.toLowerCase();
      if (seen.contains(unit)) {
        return null; // repeated unit
      }
      if (unit == '' && number != null) {
        w = number;
      } else if (numberString.isEmpty || number != null) {
        switch (unit) {
          case 'i':
            x = number ?? 1;
          case 'j':
            y = number ?? 1;
          case 'k':
            z = number ?? 1;
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
  double abs() => norm().sqrt();

  /// Returns the squared absolute value.
  num norm() => w * w + x * x + y * y + z * z;

  /// Returns the negated form of the quaternion.
  Quaternion operator -() => Quaternion(-w, -x, -y, -z);

  /// Returns the conjugate form of the quaternion.
  Quaternion conjugate() => Quaternion(w, -x, -y, -z);

  /// Returns the normalized form of the quaternion.
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
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Returns the difference of this number and another one.
  Quaternion operator -(Object other) {
    if (other is Quaternion) {
      return Quaternion(w - other.w, x - other.x, y - other.y, z - other.z);
    } else if (other is num) {
      return Quaternion(w - other, x, y, z);
    } else {
      throw ArgumentError.value(other, 'other', 'Invalid type');
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
      throw ArgumentError.value(other, 'other', 'Invalid type');
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
      throw ArgumentError.value(other, 'other', 'Invalid type');
    }
  }

  /// Computes the exponential function of this quaternion number.
  Quaternion exp() {
    final exp = w.exp();
    final norm = (x * x + y * y + z * z).sqrt();
    final scale = exp / norm * norm.sin();
    return Quaternion(exp * norm.cos(), x * scale, y * scale, z * scale);
  }

  /// Computes the natural logarithm of this quaternion number.
  Quaternion log() {
    final vectorNorm = (x * x + y * y + z * z).sqrt();
    final scale = vectorNorm.atan2(w) / vectorNorm;
    return Quaternion(0.5 * norm().log(), x * scale, y * scale, z * scale);
  }

  /// Computes the power of this quaternion number raised to [exponent].
  Quaternion pow(Object exponent) => (log() * exponent).exp();

  /// Tests if this quaternion is not defined.
  bool get isNaN => w.isNaN || x.isNaN || y.isNaN || z.isNaN;

  /// Tests if this quaternion is infinite.
  bool get isInfinite =>
      w.isInfinite || x.isInfinite || y.isInfinite || z.isInfinite;

  /// Tests if this quaternion is finite.
  bool get isFinite => w.isFinite && x.isFinite && y.isFinite && z.isFinite;

  /// Rounds the values of this quaternion to integers.
  Quaternion round() => Quaternion(w.round(), x.round(), y.round(), z.round());

  /// Floors the values of this quaternion to integers.
  Quaternion floor() => Quaternion(w.floor(), x.floor(), y.floor(), z.floor());

  /// Ceils the values of this quaternion to integers.
  Quaternion ceil() => Quaternion(w.ceil(), x.ceil(), y.ceil(), z.ceil());

  /// Truncates the values of this quaternion to integers.
  Quaternion truncate() =>
      Quaternion(w.truncate(), x.truncate(), y.truncate(), z.truncate());

  @override
  bool closeTo(Quaternion other, num epsilon) =>
      isFinite && other.isFinite && (this - other).abs() <= epsilon;

  @override
  bool operator ==(Object other) =>
      other is Quaternion &&
      w == other.w &&
      x == other.x &&
      y == other.y &&
      z == other.z;

  @override
  int get hashCode => Object.hash(w, x, y, z);

  @override
  String toString() => 'Quaternion($w, $x, $y, $z)';
}

final RegExp numberAndUnitExtractor =
    RegExp(r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)\*?(\w?)', caseSensitive: false);
