import '../../../math.dart';
import '../../../printer.dart';
import '../number.dart';
import 'sign.dart';

/// Prints numbers in a fixed format.
class FixedNumberPrinter extends NumberPrinter {
  /// Round towards the nearest number that is a multiple of accuracy.
  final double? accuracy;

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
    this.separator = '',
    this.sign = omitPositiveSign,
  })  : _integer = Printer.standard()
            .mapIf(padding > 0,
                (printer) => printer.padLeft(padding, characters[0]))
            .mapIf(separator.isNotEmpty,
                (printer) => printer.separateRight(3, 0, separator)),
        _fraction = Printer.standard()
            .mapIf(precision > 0,
                (printer) => printer.padLeft(precision, characters[0]))
            .mapIf(separator.isNotEmpty,
                (printer) => printer.separateLeft(3, 0, separator));

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    sign.printOn(object, buffer);
    if (object is num) {
      _printNumOn(object, buffer);
    } else if (object is BigInt) {
      _printBigIntOn(object, buffer);
    } else {
      invalidNumericType(object);
    }
  }

  void _printNumOn(num value, StringBuffer buffer) {
    if (value.isNaN) {
      buffer.write(nan);
    } else if (value.isInfinite) {
      buffer.write(infinity);
    } else {
      _printFloatOn(value, buffer);
    }
  }

  void _printFloatOn(num value, StringBuffer buffer) {
    final multiplier = base.pow(precision);
    final rounding = accuracy ?? 1.0 / multiplier;
    final rounded = (value / rounding).roundToDouble() * rounding;
    _printIntegerOn(rounded, buffer);
    if (precision > 0) {
      buffer.write(delimiter);
      final fractional = rounded.abs() - rounded.abs().truncate();
      _printFractionOn(fractional * multiplier, buffer);
    }
  }

  void _printIntegerOn(num value, StringBuffer buffer) {
    final digits = intDigits(value.abs().truncate(), base);
    _printIntegerDigitsOn(digits, buffer);
  }

  void _printIntegerDigitsOn(Iterable<int> digits, StringBuffer buffer) {
    final result = formatDigits(digits, characters);
    _integer.printOn(result, buffer);
  }

  void _printFractionOn(double value, StringBuffer buffer) {
    final digits = intDigits(value.round(), base);
    final result = formatDigits(digits, characters);
    _fraction.printOn(result, buffer);
  }

  void _printBigIntOn(BigInt value, StringBuffer buffer) {
    final digits = bigIntDigits(value.abs(), base);
    _printIntegerDigitsOn(digits, buffer);
  }
}
