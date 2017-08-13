library more.char_matcher.pattern;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/optimize.dart';
import 'package:more/src/char_matcher/range.dart';

CharMatcher fromPattern(String pattern) {
  // Check if negated.
  var isNegated = pattern.startsWith('^');
  if (isNegated) {
    pattern = pattern.substring(1);
  }

  // Build the range lists.
  List<RangeCharMatcher> ranges = new List();
  while (pattern.isNotEmpty) {
    if (pattern.length >= 3 && pattern[1] == '-') {
      var charMatcher = new RangeCharMatcher(pattern.codeUnitAt(0), pattern.codeUnitAt(2));
      ranges.add(charMatcher);
      pattern = pattern.substring(3);
    } else {
      var charMatcher = new RangeCharMatcher(pattern.codeUnitAt(0), pattern.codeUnitAt(0));
      ranges.add(charMatcher);
      pattern = pattern.substring(1);
    }
  }

  // Build the matcher from the ranges.
  var predicate = optimize(ranges);

  // Negate, if necessary.
  return isNegated ? ~predicate : predicate;
}
