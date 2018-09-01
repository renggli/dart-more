library more.printer.number_printer;

import 'dart:math' as math;

import '../../printer.dart';
import 'sign_printer.dart';
import 'utils.dart';

/// Lower-case digits and letters by increasing value.
const lowerCaseDigits = '0123456789abcdefghijklmnopqrstuvwxyz';

/// Upper-case digits and letters by increasing value.
const upperCaseDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// Default string for number delimiters.
const delimiterString = '.';

/// Default string for infinite values.
const infinityString = 'Infinity';

/// Default string for NaN values.
const nanString = 'NaN';

/// Default string for exponent notation.
const notationString = 'e';

/// Prints numbers in a fixed format.
class FixedNumberPrinter extends Printer {
  /// Round towards the nearest number that is a multiple of accuracy.
  final double accuracy;

  /// The numeric base to which the number should be printed.
  final int base;

  /// The characters to be used to convert a number to a string.
  final String characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String delimiter;

  /// The string that should be displayed if the number is infinite.
  final String infinity;

  /// The string that should be displayed if the number is not a number.
  final String nan;

  /// The number of digits to be printed in the fraction part.
  final int precision;

  /// The separator character to be used to group digits.
  final String separator;

  /// The printer used for negative or positive numbers.
  final Printer sign;

  FixedNumberPrinter({
    this.accuracy,
    this.base = 10,
    this.characters = lowerCaseDigits,
    this.delimiter = delimiterString,
    this.infinity = infinityString,
    this.nan = nanString,
    this.precision = 0,
    this.separator,
    this.sign = omitPositiveSign,
  });

  @override
  String call(Object object) => _prependSign(
      object, checkNumericType(object, _convertNum, _convertBigInt));

  String _prependSign(Object value, String result) {
    return '${sign(value)}$result';
  }

  String _convertNum(num value) {
    if (value.isNaN) {
      return nan;
    }
    if (value.isInfinite) {
      return infinity;
    }
    if (precision == 0) {
      return _convertInteger(value);
    } else {
      return _convertFloat(value);
    }
  }

  String _convertInteger(num value) {
    final digits = _intDigits(value.abs().truncate(), base);
    return _convertIntegerDigits(digits);
  }

  String _convertIntegerDigits(Iterable<int> digits) {
    final result = _formatDigits(digits, characters);
    return separator == null ? result : _separateRight(result, separator);
  }

  String _convertFloat(num value) {
    final buffer = StringBuffer();
    final multiplier = math.pow(base.toDouble(), precision.toDouble());
    final rounding = accuracy ?? 1.0 / multiplier;
    final rounded = (value / rounding).roundToDouble() * rounding;
    buffer.write(_convertInteger(rounded));
    if (delimiter != null) {
      buffer.write(delimiter);
    }
    final fractional = rounded.abs() - rounded.abs().truncate();
    buffer.write(_convertFraction(fractional * multiplier));
    return buffer.toString();
  }

  String _convertFraction(double value) {
    final digits = _intDigits(value.round(), base);
    final result =
        _formatDigits(digits, characters).padLeft(precision, characters[0]);
    return separator == null ? result : _separateLeft(result, separator);
  }

  String _convertBigInt(BigInt value) {
    final digits = _bigIntDigits(value.abs(), base);
    return _convertIntegerDigits(digits);
  }
}

/// Prints numbers in a scientific format.
class ScientificNumberPrinter extends Printer {
  /// The numeric base to which the number should be printed.
  final int base;

  /// The characters to be used to convert a number to a string.
  final String characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String delimiter;

  /// The string to be prepended if the exponent is positive or negative.
  final Printer exponentSign;

  /// The string that should be displayed if the number is infinite.
  final String infinity;

  /// The string to be prepended if the mantissa is positive or negative.
  final Printer mantissaSign;

  /// The string that should be displayed if the number is not a number.
  final String nan;

  /// The string separating the mantissa and exponent.
  final String notation;

  /// The number of digits to be printed in the fraction part.
  final int precision;

  /// The separator character to be used to group digits.
  final String separator;

  /// The number of significant digits to be printed.
  final int significant;

  /// The printer of the mantissa.
  final Printer _mantissa;

  /// The printer of the exponent.
  final Printer _exponent;

  ScientificNumberPrinter({
    this.base = 10,
    this.characters = lowerCaseDigits,
    this.delimiter = delimiterString,
    this.exponentSign = omitPositiveSign,
    this.infinity = infinityString,
    this.mantissaSign = omitPositiveSign,
    this.nan = nanString,
    this.notation = notationString,
    this.precision = 3,
    this.separator,
    this.significant = 1,
  })  : _mantissa = Printer.fixed(
          base: base,
          characters: characters,
          delimiter: delimiter,
          infinity: infinity,
          nan: nan,
          precision: precision,
          separator: separator,
          sign: mantissaSign,
        ),
        _exponent = Printer.fixed(
          base: base,
          characters: characters,
          separator: separator,
          sign: exponentSign,
        );

  @override
  String call(Object object) {
    final value = checkNumericType(
      object,
      (value) => value.toDouble(),
      (value) => value.toDouble(),
    );
    if (value.isInfinite || value.isNaN) {
      return _mantissa(value);
    }
    final exponent = _getExponent(value);
    final mantissa = value / math.pow(base.toDouble(), exponent.toDouble());
    final buffer = StringBuffer();
    buffer.write(_mantissa(mantissa));
    buffer.write(notation);
    buffer.write(_exponent(exponent));
    return buffer.toString();
  }

  int _getExponent(double value) {
    if (value == 0.0 || value == -0.0) {
      return 0;
    } else {
      final logBase = math.log(value.abs()) / math.log(base);
      return logBase.floor() + 1 - significant;
    }
  }
}

/// Extracts digits of a positive [value] in the provided [base].
Iterable<int> _intDigits(int value, int base) {
  if (value == 0) {
    return <int>[0];
  }
  final digits = <int>[];
  while (value > 0) {
    final next = value ~/ base;
    final index = value - next * base;
    digits.add(index);
    value = next;
  }
  return digits.reversed;
}

/// Extracts digits of a positive [value] in the provided [base].
Iterable<int> _bigIntDigits(BigInt value, int base) {
  if (value == BigInt.zero) {
    return <int>[0];
  }
  final digits = <int>[];
  final bigBase = BigInt.from(base);
  while (value > BigInt.zero) {
    final next = value ~/ bigBase;
    final index = value - next * bigBase;
    digits.add(index.toInt());
    value = next;
  }
  return digits.reversed;
}

/// Converts an iterable of [digits] to a string using [characters] mapping.
String _formatDigits(Iterable<int> digits, String characters) {
  return digits.map((digit) => characters[digit]).join();
}

/// Separates an [input] string with a [separator] from the left.
String _separateLeft(String input, String separator) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    if (i != 0 && i % 3 == 0) {
      buffer.write(separator);
    }
    buffer.writeCharCode(input.codeUnitAt(i));
  }
  return buffer.toString();
}

/// Separates an [input] string with a [separator] from the right.
String _separateRight(String input, String separator) {
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    if (i != 0 && (input.length - i) % 3 == 0) {
      buffer.write(separator);
    }
    buffer.writeCharCode(input.codeUnitAt(i));
  }
  return buffer.toString();
}
