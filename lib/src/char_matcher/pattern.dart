import 'char_matcher.dart';
import 'optimize.dart';
import 'range.dart';

CharMatcher fromPattern(String pattern) {
  // Check if negated.
  final isNegated = pattern.startsWith('^');
  if (isNegated) {
    pattern = pattern.substring(1);
  }

  // Build the range lists.
  final ranges = <RangeCharMatcher>[];
  while (pattern.isNotEmpty) {
    if (pattern.length >= 3 && pattern[1] == '-') {
      final charMatcher =
          RangeCharMatcher(pattern.codeUnitAt(0), pattern.codeUnitAt(2));
      ranges.add(charMatcher);
      pattern = pattern.substring(3);
    } else {
      final charMatcher =
          RangeCharMatcher(pattern.codeUnitAt(0), pattern.codeUnitAt(0));
      ranges.add(charMatcher);
      pattern = pattern.substring(1);
    }
  }

  // Build the matcher from the ranges.
  final predicate = optimize(ranges);

  // Negate, if necessary.
  return isNegated ? ~predicate : predicate;
}
