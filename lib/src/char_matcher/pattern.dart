library more.char_matcher.pattern;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/negate.dart';
import 'package:more/src/char_matcher/none.dart';
import 'package:more/src/char_matcher/range.dart';
import 'package:more/src/char_matcher/ranges.dart';
import 'package:more/src/char_matcher/single.dart';

CharMatcher toCharMatcher(String pattern) {
  // 1. Verify if it is negated.
  var isNegated = pattern.startsWith('^');
  if (isNegated) {
    pattern = pattern.substring(1);
  }

  // 2. Build the range lists.
  List<RangeCharMatcher> ranges = new List();
  while (pattern.isNotEmpty) {
    if (pattern.length >= 3 && pattern[1] == '-') {
      ranges.add(
          new RangeCharMatcher(pattern.codeUnitAt(0), pattern.codeUnitAt(2)));
      pattern = pattern.substring(3);
    } else {
      ranges.add(
          new RangeCharMatcher(pattern.codeUnitAt(0), pattern.codeUnitAt(0)));
      pattern = pattern.substring(1);
    }
  }

  // 3. Sort the range lists.
  List<RangeCharMatcher> sortedRanges = new List.from(ranges, growable: false);
  sortedRanges.sort((RangeCharMatcher a, RangeCharMatcher b) {
    return a.start != b.start ? a.start - b.start : a.stop - b.stop;
  });

  // 4. Merge adjacent or overlapping ranges.
  List<RangeCharMatcher> mergedRanges = new List();
  for (var thisRange in sortedRanges) {
    if (mergedRanges.isEmpty) {
      mergedRanges.add(thisRange);
    } else {
      var lastRange = mergedRanges.last;
      if (lastRange.stop + 1 >= thisRange.start) {
        var characterRange =
            new RangeCharMatcher(lastRange.start, thisRange.stop);
        mergedRanges[mergedRanges.length - 1] = characterRange;
      } else {
        mergedRanges.add(thisRange);
      }
    }
  }

  // 5. Build the best resulting predicates
  CharMatcher predicate;
  if (mergedRanges.isEmpty) {
    predicate = none;
  } else if (mergedRanges.length == 1) {
    if (mergedRanges[0].start == mergedRanges[0].stop) {
      predicate = new SingleCharMatcher(mergedRanges[0].start);
    } else {
      predicate = mergedRanges[0];
    }
  } else {
    predicate = new RangesCharMatcher(
        mergedRanges.length,
        mergedRanges.map((range) => range.start).toList(growable: false),
        mergedRanges.map((range) => range.stop).toList(growable: false));
  }

  // 6. Negate, if necessary.
  return isNegated ? new NegateCharMatcher(predicate) : predicate;
}
