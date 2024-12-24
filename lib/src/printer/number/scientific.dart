import '../../../math.dart';
import '../object/object.dart';
import '../printer.dart';
import 'fixed.dart';
import 'numeral.dart';
import 'sign.dart';
import 'utils.dart';

/// Prints numbers in a scientific format.
class ScientificNumberPrinter<T extends num> extends Printer<T> {
  /// Prints numbers in a custom scientific format.
  ScientificNumberPrinter({
    this.base = 10,
    this.characters = NumeralSystem.latin,
    this.delimiter = delimiterString,
    this.exponentPadding = 0,
    this.exponentSign,
    this.infinity = infinityString,
    this.mantissaPadding = 0,
    this.mantissaSign,
    this.nan = nanString,
    this.notation = notationString,
    this.precision = 3,
    this.separator = '',
    this.separatorWidth = 3,
    this.separatorOffset = 0,
    this.significant = 1,
  })  : _mantissa = FixedNumberPrinter<double>(
          base: base,
          characters: characters,
          delimiter: delimiter,
          infinity: infinity,
          nan: nan,
          padding: mantissaPadding,
          precision: precision,
          separator: separator,
          separatorWidth: separatorWidth,
          separatorOffset: separatorOffset,
          sign: mantissaSign ??
              const SignNumberPrinter<double>.omitPositiveSign(),
        ),
        _exponent = FixedNumberPrinter<int>(
          base: base,
          characters: characters,
          padding: exponentPadding,
          separator: separator,
          separatorWidth: separatorWidth,
          separatorOffset: separatorOffset,
          sign: exponentSign ?? const SignNumberPrinter<int>.omitPositiveSign(),
        );

  /// The numeric base to which the number should be printed.
  final int base;

  /// The characters to be used to convert a number to a string.
  final List<String> characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String delimiter;

  /// The number of digits to be printed in the exponent.
  final int exponentPadding;

  /// The string to be prepended if the exponent is positive or negative.
  final Printer<int>? exponentSign;

  /// The string that should be displayed if the number is infinite.
  final String infinity;

  /// The number of digits to be printed in the mantissa.
  final int mantissaPadding;

  /// The string to be prepended if the mantissa is positive or negative.
  final Printer<double>? mantissaSign;

  /// The string that should be displayed if the number is not a number.
  final String nan;

  /// The string separating the mantissa and exponent.
  final String notation;

  /// The number of digits to be printed in the fraction part.
  final int precision;

  /// The separator character to be used to group digits.
  final String separator;

  /// The number of characters to be separated in a group.
  final int separatorWidth;

  /// The offset of characters to be separated in a group.
  final int separatorOffset;

  /// The number of significant digits to be printed.
  final int significant;

  /// The (internal) printer of the mantissa.
  final Printer<double> _mantissa;

  /// The (internal) printer of the exponent.
  final Printer<int> _exponent;

  @override
  void printOn(T object, StringBuffer buffer) {
    final value = object.toDouble();
    if (value.isInfinite || value.isNaN) {
      return _mantissa.printOn(value, buffer);
    }
    final exponent = _getExponent(value);
    final mantissa = value / base.toDouble().pow(exponent);
    _mantissa.printOn(mantissa, buffer);
    buffer.write(notation);
    _exponent.printOn(exponent, buffer);
  }

  int _getExponent(double value) {
    if (value == 0.0 || value == -0.0) {
      return 0;
    } else {
      final logBase = value.abs().log() / base.log();
      return logBase.floor() + 1 - significant;
    }
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(base, name: 'base')
    ..addValue(characters, name: 'characters')
    ..addValue(delimiter, name: 'delimiter')
    ..addValue(exponentPadding, name: 'exponentPadding')
    ..addValue(exponentSign, name: 'exponentSign')
    ..addValue(infinity, name: 'infinity')
    ..addValue(mantissaPadding, name: 'mantissaPadding')
    ..addValue(mantissaSign, name: 'mantissaSign')
    ..addValue(nan, name: 'nan')
    ..addValue(notation, name: 'notation')
    ..addValue(precision, name: 'precision')
    ..addValue(separator, name: 'separator')
    ..addValue(significant, name: 'significant');
}
