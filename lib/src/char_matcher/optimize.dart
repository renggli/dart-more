library more.char_matcher.optimize;

import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/none.dart';
import 'package:more/src/char_matcher/range.dart';
import 'package:more/src/char_matcher/ranges.dart';
import 'package:more/src/char_matcher/single.dart';

CharMatcher optimize(Iterable<RangeCharMatcher> ranges) {
  // Sort the range lists.
  List<RangeCharMatcher> sortedRanges = new List.from(ranges, growable: false);
  sortedRanges.sort((RangeCharMatcher a, RangeCharMatcher b) {
    return a.start != b.start ? a.start - b.start : a.stop - b.stop;
  });

  // Merge adjacent or overlapping ranges.
  List<RangeCharMatcher> mergedRanges = new List();
  for (var thisRange in sortedRanges) {
    if (mergedRanges.isEmpty) {
      mergedRanges.add(thisRange);
    } else {
      var lastRange = mergedRanges.last;
      if (lastRange.stop + 1 >= thisRange.start) {
        var charMatcher = new RangeCharMatcher(lastRange.start, thisRange.stop);
        mergedRanges[mergedRanges.length - 1] = charMatcher;
      } else {
        mergedRanges.add(thisRange);
      }
    }
  }

  // Build the best resulting predicate.
  if (mergedRanges.isEmpty) {
    return const NoneCharMatcher();
  } else if (mergedRanges.length == 1) {
    if (mergedRanges[0].start == mergedRanges[0].stop) {
      return new SingleCharMatcher(mergedRanges[0].start);
    } else {
      return mergedRanges[0];
    }
  } else {
    return new RangesCharMatcher(
        mergedRanges.length,
        mergedRanges.map((range) => range.start).toList(growable: false),
        mergedRanges.map((range) => range.stop).toList(growable: false));
  }
}
