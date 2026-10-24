import '../../comparator/compare_extensions.dart';
import '../printer.dart';
import '../sequence.dart';
import 'fixed.dart';
import 'numeral.dart';
import 'sign.dart';

/// Prints a unicode code-point.
final unicodeCodePointPrinter = Printer<int>.sequence([
  const Printer<int>.literal('U'),
  FixedNumberPrinter<int>(
    base: 16,
    characters: NumeralSystem.upperCaseLatin,
    padding: 4,
    sign: const SignNumberPrinter<int>.negativeAndPositiveSign(),
  ),
  Printer<int>.switcher({
    (value) => !value.between(0, 0x10ffff): const Printer<int>.literal(
      ' (invalid)',
    ),
    _isPrintable: const Printer<int>.pluggable(String.fromCharCode)
        .around(' "', '"'),
  }, otherwise: const Printer<int>.literal('')),
]);

bool _isPrintable(int value) =>
    (value >= 0x20 && value < 0x7f) ||
    (value >= 0xa0 &&
        value != 0xad &&
        !(value >= 0xd800 && value <= 0xdfff) &&
        !(value >= 0xe000 && value <= 0xf8ff) &&
        !(value >= 0xf0000 && value <= 0xffffd) &&
        !(value >= 0x100000 && value <= 0x10fffd) &&
        !((value & 0xfffe) == 0xfffe) &&
        !(value >= 0xfdd0 && value <= 0xfdef));
