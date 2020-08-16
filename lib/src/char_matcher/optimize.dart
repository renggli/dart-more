import '../../char_matcher.dart';
import '../collection/bitlist.dart';
import 'any.dart';
import 'lookup.dart';
import 'none.dart';
import 'range.dart';
import 'ranges.dart';
import 'single.dart';

CharMatcher optimize(Iterable<RangeCharMatcher> ranges) {
  // Sort the range lists.
  final sortedRanges = List.of(ranges, growable: false);
  sortedRanges
      .sort((a, b) => a.start != b.start ? a.start - b.start : a.stop - b.stop);

  // Merge adjacent or overlapping ranges.
  final mergedRanges = <RangeCharMatcher>[];
  for (final thisRange in sortedRanges) {
    if (mergedRanges.isEmpty) {
      mergedRanges.add(thisRange);
    } else {
      final lastRange = mergedRanges.last;
      if (lastRange.stop + 1 >= thisRange.start) {
        final charMatcher = RangeCharMatcher(lastRange.start, thisRange.stop);
        mergedRanges[mergedRanges.length - 1] = charMatcher;
      } else {
        mergedRanges.add(thisRange);
      }
    }
  }

  // Build the best resulting predicate.
  final matchingCount = mergedRanges.fold(
      0, (current, range) => current + (range.stop - range.start + 1));
  if (matchingCount == 0) {
    return const NoneCharMatcher();
  } else if (matchingCount - 1 == 0xffff) {
    return const AnyCharMatcher();
  } else if (mergedRanges.length == 1) {
    if (mergedRanges[0].start == mergedRanges[0].stop) {
      return SingleCharMatcher(mergedRanges[0].start);
    } else {
      return mergedRanges[0];
    }
  } else {
    final rangesSize = 2 * mergedRanges.length;
    final lookupBits = mergedRanges.last.stop - mergedRanges.first.start + 1;
    final lookupSize = (lookupBits + 31) >> 5;
    // Arbitrary trade-off: Do not create lookup tables larger than 0xff
    // elements, unless the range tables are larger.
    if (lookupSize < 0xff || lookupSize < rangesSize) {
      final buffer = BitList(lookupBits);
      for (final mergedRange in mergedRanges) {
        for (var char = mergedRange.start; char <= mergedRange.stop; char++) {
          buffer.setUnchecked(char - mergedRanges.first.start, true);
        }
      }
      return LookupCharMatcher(
          mergedRanges.first.start, mergedRanges.last.stop, buffer);
    } else {
      return RangesCharMatcher(
          mergedRanges.length,
          mergedRanges.map((range) => range.start).toList(growable: false),
          mergedRanges.map((range) => range.stop).toList(growable: false));
    }
  }
}
