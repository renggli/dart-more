/// Parses a [source] string with numbers and units.
///
/// The parser is able to extract multiple number/unit pairs from a string.
/// For example, the string `'10i - 2'` is parsed into `{'i': 10, '': -2}`.
///
/// The set of allowed [units] has to be specified. The empty string `''`
/// denotes a unit-less number.
///
/// Returns `null` if the [source] is empty, contains an invalid number or
/// unit, has unrecognized characters, or if a unit is repeated.
Map<String, num>? parseWithUnits(String source, {required Set<String> units}) {
  if (_splitNumberWhitespace.hasMatch(source) ||
      _splitExponentWhitespace.hasMatch(source)) {
    return null;
  }
  final cleaned = source.replaceAll(_whitespace, '');
  if (cleaned.isEmpty) return null;
  final parts = _numberAndUnitExtractor
      .allMatches(cleaned)
      .where((match) => match.start < match.end)
      .toList();
  if (parts.isEmpty) return null; // empty input
  final result = <String, num>{};
  var lastEnd = 0;
  for (final part in parts) {
    if (part.start != lastEnd) return null; // unrecognized characters
    final numberString = part.group(1) ?? '';
    if (lastEnd > 0 &&
        !numberString.startsWith('+') &&
        !numberString.startsWith('-')) {
      return null; // missing operator between terms
    }
    lastEnd = part.end;
    final hasStar = (part.group(4) ?? '').isNotEmpty;
    final number = num.tryParse(numberString);
    final unitString = part.group(5) ?? '';
    final unit = unitString.toLowerCase();
    if (hasStar && (number == null || unit.isEmpty)) {
      return null; // bare * before or without unit
    }
    if (!units.contains(unit)) return null; // invalid unit
    if (result.containsKey(unit)) return null; // repeated unit
    if (number != null) {
      result[unit] = number;
    } else if (unit.isNotEmpty &&
        (numberString.isEmpty || numberString == '+')) {
      result[unit] = 1;
    } else if (unit.isNotEmpty && numberString == '-') {
      result[unit] = -1;
    } else {
      return null; // invalid number
    }
  }
  if (lastEnd != cleaned.length) {
    return null; // trailing unrecognized characters
  }
  return result;
}

final RegExp _splitNumberWhitespace = RegExp(r'(\d|\.)\s+(\d|\.)');
final RegExp _splitExponentWhitespace = RegExp(
  r'(\d|\.)\s+[eE]|[eE]\s+[+-]?\s*\d|[eE][+-]\s+\d',
);
final RegExp _whitespace = RegExp(r'\s+');
final RegExp _numberAndUnitExtractor = RegExp(
  r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)(\*?)(\w?)',
  caseSensitive: false,
);
