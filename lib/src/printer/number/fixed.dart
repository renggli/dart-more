import '../../../math.dart';
import '../../../printer.dart';
import '../number.dart';
import 'sign.dart';

/// Prints numbers in a fixed format.
class FixedNumberPrinter extends NumberPrinter {
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

  /// The number of digits to be printed in the integer part.
  final int padding;

  /// The number of digits to be printed in the fraction part.
  final int precision;

  /// The separator character to be used to group digits.
  final String separator;

  /// The printer used for negative or positive numbers.
  final Printer sign;

  /// Internal integer printer.
  final Printer _integer;

  /// Internal fraction printer.
  final Printer _fraction;

  FixedNumberPrinter({
    this.accuracy,
    this.base = 10,
    this.characters = lowerCaseDigits,
    this.delimiter = delimiterString,
    this.infinity = infinityString,
    this.nan = nanString,
    this.padding = 0,
    this.precision = 0,
    this.separator,
    this.sign = omitPositiveSign,
  })  : _integer = Printer.standard()
            .mapIf(padding > 0,
                (printer) => printer.padLeft(padding, characters[0]))
            .mapIf(separator != null,
                (printer) => printer.separateRight(3, 0, separator)),
        _fraction = Printer.standard()
            .mapIf(precision > 0,
                (printer) => printer.padLeft(precision, characters[0]))
            .mapIf(separator != null,
                (printer) => printer.separateLeft(3, 0, separator));

  @override
  String call(Object object) => _prependSign(
      object, checkNumericType(object, _convertNum, _convertBigInt));

  String _prependSign(Object value, String result) => '${sign(value)}$result';

  String _convertNum(num value) {
    if (value.isNaN) {
      return nan;
    }
    if (value.isInfinite) {
      return infinity;
    }
    return _convertFloat(value);
  }

  String _convertFloat(num value) {
    final buffer = StringBuffer();
    final multiplier = base.pow(precision);
    final rounding = accuracy ?? 1.0 / multiplier;
    final rounded = (value / rounding).roundToDouble() * rounding;
    buffer.write(_convertInteger(rounded));
    if (precision > 0) {
      if (delimiter != null) {
        buffer.write(delimiter);
      }
      final fractional = rounded.abs() - rounded.abs().truncate();
      buffer.write(_convertFraction(fractional * multiplier));
    }
    return buffer.toString();
  }

  String _convertInteger(num value) {
    final digits = intDigits(value.abs().truncate(), base);
    return _convertIntegerDigits(digits);
  }

  String _convertIntegerDigits(Iterable<int> digits) {
    final result = formatDigits(digits, characters);
    return _integer(result);
  }

  String _convertFraction(double value) {
    final digits = intDigits(value.round(), base);
    final result = formatDigits(digits, characters);
    return _fraction(result);
  }

  String _convertBigInt(BigInt value) {
    final digits = bigIntDigits(value.abs(), base);
    return _convertIntegerDigits(digits);
  }
}
