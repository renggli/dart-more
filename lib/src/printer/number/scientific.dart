import '../../../math.dart';
import '../../../printer.dart';
import '../number.dart';
import 'fixed.dart';
import 'sign.dart';

/// Prints numbers in a scientific format.
class ScientificNumberPrinter extends NumberPrinter {
  /// The numeric base to which the number should be printed.
  final int base;

  /// The characters to be used to convert a number to a string.
  final String characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String delimiter;

  /// The number of digits to be printed in the exponent.
  final int exponentPadding;

  /// The string to be prepended if the exponent is positive or negative.
  final Printer exponentSign;

  /// The string that should be displayed if the number is infinite.
  final String infinity;

  /// The number of digits to be printed in the mantissa.
  final int mantissaPadding;

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

  /// The (internal) printer of the mantissa.
  final Printer _mantissa;

  /// The (internal) printer of the exponent.
  final Printer _exponent;

  ScientificNumberPrinter({
    this.base = 10,
    this.characters = lowerCaseDigits,
    this.delimiter = delimiterString,
    this.exponentPadding = 0,
    this.exponentSign = omitPositiveSign,
    this.infinity = infinityString,
    this.mantissaPadding = 0,
    this.mantissaSign = omitPositiveSign,
    this.nan = nanString,
    this.notation = notationString,
    this.precision = 3,
    this.separator = '',
    this.significant = 1,
  })  : _mantissa = FixedNumberPrinter(
          base: base,
          characters: characters,
          delimiter: delimiter,
          infinity: infinity,
          nan: nan,
          padding: mantissaPadding,
          precision: precision,
          separator: separator,
          sign: mantissaSign,
        ),
        _exponent = FixedNumberPrinter(
          base: base,
          characters: characters,
          padding: exponentPadding,
          separator: separator,
          sign: exponentSign,
        );

  @override
  String call(dynamic object) {
    final value = checkNumericType(
      object,
      (value) => value.toDouble(),
      (value) => value.toDouble(),
    );
    if (value.isInfinite || value.isNaN) {
      return _mantissa(value);
    }
    final exponent = _getExponent(value);
    final mantissa = value / base.toDouble().pow(exponent);
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
      final logBase = value.abs().log() / base.log();
      return logBase.floor() + 1 - significant;
    }
  }
}
