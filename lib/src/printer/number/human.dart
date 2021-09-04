import '../../../math.dart';
import '../../../printer.dart';
import '../number.dart';
import 'fixed.dart';
import 'sign.dart';

// https://en.wikipedia.org/wiki/Binary_prefix.
const binaryUnitBase = 1024;
const binaryUnitOffset = 0;
const binaryUnitsShort = [
  '',
  'Ki',
  'Mi',
  'Gi',
  'Ti',
  'Pi',
  'Ei',
  'Zi',
  'Yi',
];
const binaryUnitsLong = [
  '',
  'kibi',
  'mebi',
  'gibi',
  'tebi',
  'pebi',
  'exbi',
  'zebi',
  'yobi',
];

// Definitions for https://en.wikipedia.org/wiki/Metric_prefix.
const decimalUnitBase = 1000;
const decimalUnitOffset = 8;
const decimalUnitsShort = [
  'y',
  'z',
  'a',
  'f',
  'p',
  'n',
  'µ',
  'm',
  '',
  'k',
  'M',
  'G',
  'T',
  'P',
  'E',
  'Z',
  'Y',
];
const decimalUnitsLong = [
  'yocto',
  'zepto',
  'atto',
  'femto',
  'pico',
  'nano',
  'micro',
  'milli',
  '',
  'kilo',
  'mega',
  'giga',
  'tera',
  'peta',
  'exa',
  'zetta',
  'yotta',
];

/// Prints numbers in a custom human readable string.
class HumanNumberPrinter extends NumberPrinter {
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

  /// The number of digits to be printed.
  final int padding;

  /// The number of digits to be printed in the fraction part.
  final int precision;

  /// The separator character to be used to group digits.
  final String separator;

  /// The string to be prepended if the number is positive or negative.
  final Printer sign;

  /// The base of the unit to be printed.
  final int unitBase;

  /// The exponent offset of the units to be printed.
  final int unitOffset;

  /// Whether the unit should be used as a prefix, instead of an suffix.
  final bool unitPrefix;

  /// Separator between value and unit.
  final String unitSeparator;

  /// The units to be used.
  final List<String> units;

  /// The (internal) printer of the mantissa.
  final Printer _mantissa;

  /// Prints numbers in a custom human readable string.
  HumanNumberPrinter({
    required this.units,
    this.base = 10,
    this.characters = lowerCaseDigits,
    this.delimiter = delimiterString,
    this.infinity = infinityString,
    this.nan = nanString,
    this.padding = 0,
    this.precision = 0,
    this.separator = '',
    this.sign = omitPositiveSign,
    this.unitBase = 10,
    this.unitOffset = 0,
    this.unitPrefix = false,
    this.unitSeparator = ' ',
  }) : _mantissa = FixedNumberPrinter(
          base: base,
          characters: characters,
          delimiter: delimiter,
          infinity: infinity,
          nan: nan,
          padding: padding,
          precision: precision,
          separator: separator,
          sign: sign,
        );

  /// Prints numbers using a decimal suffix for units measure to indicate a
  /// multiple or sub-multiple of the unit.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Metric_prefix.
  factory HumanNumberPrinter.decimal({
    int base = 10,
    String characters = lowerCaseDigits,
    String delimiter = delimiterString,
    String infinity = infinityString,
    bool long = false,
    String nan = nanString,
    int padding = 0,
    int precision = 0,
    String separator = '',
    Printer sign = omitPositiveSign,
    bool unitPrefix = false,
    String unitSeparator = ' ',
  }) =>
      HumanNumberPrinter(
        base: base = 10,
        characters: characters,
        delimiter: delimiter,
        infinity: infinity,
        nan: nan,
        padding: padding,
        precision: precision,
        separator: separator,
        sign: sign,
        unitPrefix: unitPrefix,
        unitSeparator: unitSeparator,
        unitBase: decimalUnitBase,
        unitOffset: decimalUnitOffset,
        units: long ? decimalUnitsLong : decimalUnitsShort,
      );

  /// Prints numbers using a binary suffix for units in data processing, data
  /// transmission, and digital information.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Binary_prefix.
  factory HumanNumberPrinter.binary({
    int base = 10,
    String characters = lowerCaseDigits,
    String delimiter = delimiterString,
    String infinity = infinityString,
    bool long = false,
    String nan = nanString,
    int padding = 0,
    int precision = 0,
    String separator = '',
    Printer sign = omitPositiveSign,
    bool unitPrefix = false,
    String unitSeparator = ' ',
  }) =>
      HumanNumberPrinter(
        base: base,
        characters: characters,
        delimiter: delimiter,
        infinity: infinity,
        nan: nan,
        padding: padding,
        precision: precision,
        separator: separator,
        sign: sign,
        unitPrefix: unitPrefix,
        unitSeparator: unitSeparator,
        unitBase: binaryUnitBase,
        units: long ? binaryUnitsLong : binaryUnitsShort,
      );

  @override
  void printOn(dynamic object, StringBuffer buffer) {
    final value = object is num
        ? object.toDouble()
        : object is BigInt
            ? object.toDouble()
            : invalidNumericType(object);
    if (value.isInfinite || value.isNaN) {
      _mantissa.printOn(object, buffer);
    } else {
      final index = _getExponent(value) + unitOffset;
      final unitIndex = index.clamp(0, units.length - 1);
      final unitString = units[unitIndex];
      final unitExponent = unitIndex - unitOffset;
      final mantissa = value / unitBase.toDouble().pow(unitExponent);
      if (unitString.isEmpty) {
        _mantissa.printOn(mantissa, buffer);
      } else if (unitPrefix) {
        buffer.write(unitString);
        buffer.write(unitSeparator);
        _mantissa.printOn(mantissa, buffer);
      } else {
        _mantissa.printOn(mantissa, buffer);
        buffer.write(unitSeparator);
        buffer.write(unitString);
      }
    }
  }

  int _getExponent(double value) {
    if (value == 0.0 || value == -0.0) {
      return 0;
    } else {
      return (value.abs().log() / unitBase.log()).floor();
    }
  }
}
