/// Parses a [source] string with numbers and units.
///
/// The parser is able to extract multiple number/unit pairs from a string.
/// For example, the string `'10i - 2'` is parsed into `{'i': 10, '': -2}`.
///
/// The set of allowed [units] has to be specified. The empty string `''`
/// denotes a unit-less number.
///
/// Throws a [FormatException] if the [source] is empty, contains an invalid
/// number or unit, or if a unit is repeated.
Map<String, num>? parseWithUnits(String source, {required Set<String> units}) {
  final parts = numberAndUnitExtractor
      .allMatches(source.replaceAll(' ', ''))
      .where((match) => match.start < match.end)
      .toList();
  if (parts.isEmpty) return null; // empty input
  final result = <String, num>{};
  for (final part in parts) {
    final numberString = part.group(1) ?? '';
    final number = num.tryParse(numberString);
    final unitString = part.group(4) ?? '';
    final unit = unitString.toLowerCase();
    if (!units.contains(unit)) return null; // invalid unit
    if (result.containsKey(unit)) return null; // repeated unit
    if (number != null) {
      result[unit] = number;
    } else if (numberString.isEmpty || numberString == '+') {
      result[unit] = 1;
    } else if (numberString == '-') {
      result[unit] = -1;
    } else {
      return null; // invalid number
    }
  }
  return result;
}

final RegExp numberAndUnitExtractor = RegExp(
  r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)\*?(\w?)',
  caseSensitive: false,
);
