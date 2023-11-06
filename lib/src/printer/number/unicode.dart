import '../../../more.dart';

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
    (value) => !value.between(0, 0x10ffff):
        const Printer<int>.literal(' (invalid)'),
    (~const CharMatcher.other()).match:
        const Printer<int>.pluggable(String.fromCharCode).around(' "', '"'),
  }, otherwise: const Printer<int>.literal('')),
]);
