library more.printer.number_printer;

import 'dart:math' as math;

import '../../printer.dart';
import 'utils.dart';

/// Prints numbers in a fixed format.
class FixedNumberPrinter extends Printer {
  /// Round towards the nearest number that is a multiple of accuracy.
  final double _accuracy;

  /// The numeric base to which the number should be printed.
  final int _base;

  /// The characters to be used to convert a number to a string.
  final String _characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String _delimiter;

  /// The string that should be displayed if the number is infinite.
  final String _infinity;

  /// The string that should be displayed if the number is not a number.
  final String _nan;

  /// The way the sign of the number is printed.
  final Printer _sign;

  /// The number of digits to be printed in the fraction part.
  final int _precision;

  /// The separator character to be used to group digits.
  final String _separator;

  FixedNumberPrinter(
      this._accuracy,
      this._base,
      this._characters,
      this._delimiter,
      this._infinity,
      this._nan,
      this._precision,
      this._sign,
      this._separator);

  @override
  String call(Object object) =>
      checkNumericType(object, _convertNumber, _convertBigInt);

  String _convertNumber(num value) {
    if (value.isNaN) {
      return _nan;
    }
    if (value.isInfinite) {
      return _infinity;
    }
    if (_precision == 0) {
      return _convertInteger(value);
    } else {
      return _convertFloat(value);
    }
  }

  String _convertInteger(num value) {
    final digits = _intDigits(value.abs().truncate(), _base);
    return _convertIntegerDigits(digits);
  }

  String _convertIntegerDigits(Iterable<int> digits) {
    final result = _formatDigits(digits, _characters);
    return _separator == null ? result : _separateRight(result, _separator);
  }

  String _convertFloat(num value) {
    final buffer = StringBuffer();
    final multiplier = math.pow(_base, _precision);
    final accuracy = _accuracy ?? 1.0 / multiplier;
    final rounded = (value / accuracy).roundToDouble() * accuracy;
    buffer.write(_convertInteger(rounded));
    if (_delimiter != null) {
      buffer.write(_delimiter);
    }
    final fractional = rounded.abs() - rounded.abs().truncate();
    buffer.write(_convertFraction(fractional * multiplier));
    return buffer.toString();
  }

  String _convertFraction(double value) {
    final digits = _intDigits(value.round(), _base);
    final result =
        _formatDigits(digits, _characters).padLeft(_precision, _characters[0]);
    return _separator == null ? result : _separateLeft(result, _separator);
  }

  String _convertBigInt(BigInt value) {
    final digits = _bigIntDigits(value.abs(), _base);
    return _convertIntegerDigits(digits);
  }
}

class ScientificNumberPrinter extends Printer {
  /// The numeric base to which the number should be printed.
  final int _base;

  /// The number of significant digits to be printed.
  final int _significant;

  /// The string separating the mantissa and exponent.
  final String _notation;

  /// The printer of the mantissa.
  final Printer _mantissa;

  /// The printer of the exponent.
  final Printer _exponent;

  ScientificNumberPrinter(
      this._base,
      String characters,
      String delimiter,
      String infinity,
      String nan,
      this._notation,
      int precision,
      String separator,
      this._significant)
      : _mantissa = Printer.sign() +
            Printer.number(
                base: _base,
                characters: characters,
                delimiter: delimiter,
                infinity: infinity,
                nan: nan,
                precision: precision,
                separator: separator),
        _exponent = Printer.sign() +
            Printer.number(
                base: _base, characters: characters, separator: separator);

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
    final mantissa = value / math.pow(_base, exponent);
    final buffer = StringBuffer();
    buffer.write(_mantissa(mantissa));
    buffer.write(_notation);
    buffer.write(_exponent(exponent));
    return buffer.toString();
  }

  int _getExponent(double value) {
    if (value == 0.0 || value == -0.0) {
      return 0;
    } else {
      final logBase = math.log(value.abs()) / math.log(_base);
      return logBase.floor() + 1 - _significant;
    }
  }
}

/// Extracts digits of an [int] [value] in the provided [base].
Iterable<int> _intDigits(int value, int base) {
  if (value == 0) {
    return [0];
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

/// Extracts digits of a [BitInt] [value] in the provided [base].
Iterable<int> _bigIntDigits(BigInt value, int base) {
  if (value == BigInt.zero) {
    return [0];
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
