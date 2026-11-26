import '../basic/range.dart';
import '../char_matcher.dart';
import 'optimize.dart';

CharMatcher fromPattern(String input) {
  final runes = input.runes.toList(growable: false);
  return _fromPattern(runes, 0, runes.length);
}

CharMatcher _fromPattern(List<int> pattern, int start, int end) {
  // Negation: ^pattern.
  final isNegated = start < end && _negateMatcher.match(pattern[start]);
  if (isNegated) start++;

  final ranges = <RangeCharMatcher>[];
  var index = start;
  while (index < end) {
    final remaining = end - index;
    if (ranges.isNotEmpty &&
        remaining > 2 &&
        _rangeMatcher.match(pattern[index]) &&
        _openMatcher.match(pattern[index + 1]) &&
        _closeMatcher.match(pattern[end - 1])) {
      // Subtraction: base-[subtract]
      final base = _completePattern(ranges, isNegated);
      final subtract = _fromPattern(pattern, index + 2, end - 1);
      return base & ~subtract;
    } else if (remaining > 2 &&
        _rangeMatcher.match(pattern[index + 1]) &&
        !(remaining > 3 &&
            _openMatcher.match(pattern[index + 2]) &&
            _closeMatcher.match(pattern[end - 1]))) {
      // Ranges: start-stop
      final rangeStart = pattern[index];
      final rangeStop = pattern[index + 2];
      if (rangeStart > rangeStop) {
        throw ArgumentError('Invalid range: $rangeStart-$rangeStop');
      }
      ranges.add(RangeCharMatcher(rangeStart, rangeStop));
      index += 3;
    } else {
      // Single character
      final char = pattern[index++];
      ranges.add(RangeCharMatcher(char, char));
    }
  }
  return _completePattern(ranges, isNegated);
}

CharMatcher _completePattern(List<RangeCharMatcher> ranges, bool isNegated) {
  final predicate = optimize(ranges);
  return isNegated ? ~predicate : predicate;
}

final _negateMatcher = CharMatcher.isChar('^');
final _rangeMatcher = CharMatcher.isChar('-');
final _openMatcher = CharMatcher.isChar('[');
final _closeMatcher = CharMatcher.isChar(']');
