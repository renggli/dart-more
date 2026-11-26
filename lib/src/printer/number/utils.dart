import '../../math/math.dart';

/// Default string for number delimiters.
const String delimiterString = '.';

/// Default string for infinite values.
const String infinityString = 'Infinity';

/// Default string for NaN values.
const String nanString = 'NaN';

/// Default string for exponent notation.
const String notationString = 'e';

/// Extracts digits of an `int` [value] in the provided [base].
Iterable<int> intDigits(int value, int base) {
  if (value == 0) {
    return <int>[0];
  }
  final digits = <int>[];
  while (value != 0) {
    final next = value ~/ base;
    digits.add((value - next * base).abs());
    value = next;
  }
  return digits.reversed;
}

/// Extracts digits of a `BigInt` [value] in the provided [base].
Iterable<int> bigIntDigits(BigInt value, int base) {
  if (value == BigInt.zero) {
    return <int>[0];
  }
  final bigBase = BigInt.from(base);
  var current = value.abs();
  final digits = <int>[];
  while (current > BigInt.zero) {
    final next = current ~/ bigBase;
    digits.add((current - next * bigBase).toInt());
    current = next;
  }
  return digits.reversed;
}

final BigInt _doubleChunk = BigInt.one << 52;
const double _doubleChunkDouble = 4503599627370496.0;

/// Converts a finite non-negative integral [double] to a [BigInt] without
/// losing precision.
BigInt doubleToBigInt(double value) {
  if (value == 0.0) return BigInt.zero;
  final parts = <int>[];
  var current = value.truncateToDouble();
  while (current > 0.0) {
    final next = (current / _doubleChunkDouble).floorToDouble();
    parts.add((current - next * _doubleChunkDouble).round());
    current = next;
  }
  var result = BigInt.zero;
  for (var i = parts.length - 1; i >= 0; i--) {
    result = result * _doubleChunk + BigInt.from(parts[i]);
  }
  return result;
}

/// Divides [value] by `base^exponent`, splitting the scaling into two steps
/// when a single step would underflow or overflow.
double scaleByBasePow(double value, int base, int exponent) {
  if (exponent == 0 || value == 0.0) return value;
  final scale = base.toDouble().pow(exponent);
  if (scale.isFinite && scale != 0.0) {
    return value / scale;
  }
  final half = exponent ~/ 2;
  final rest = exponent - half;
  return (value / base.toDouble().pow(half)) / base.toDouble().pow(rest);
}

/// Extracts [precision] fractional digits in [base] from a non-negative
/// [fraction] (`0 <= fraction < 1`), rounding half away from zero and returning
/// any carry into the integer part.
({List<int> digits, bool carry}) extractFractionDigits(
  double fraction,
  int base,
  int precision,
) {
  if (precision == 0) {
    return (digits: const [], carry: fraction >= 0.5);
  }
  final digits = List<int>.filled(precision, 0);
  var rem = fraction;
  for (var i = 0; i < precision; i++) {
    rem *= base;
    final digit = rem.floor();
    digits[i] = digit;
    rem -= digit;
  }
  var carry = rem >= 0.5 ? 1 : 0;
  for (var i = precision - 1; i >= 0; i--) {
    final sum = digits[i] + carry;
    if (sum >= base) {
      digits[i] = sum - base;
      carry = 1;
    } else {
      digits[i] = sum;
      carry = 0;
    }
  }
  return (digits: digits, carry: carry > 0);
}

/// Converts an iterable of [digits] to a string using [characters] mapping.
String formatDigits(Iterable<int> digits, List<String> characters) =>
    digits.map((digit) => characters[digit]).join();
