import 'char_matcher.dart';
import 'optimize.dart';
import 'range.dart';

CharMatcher fromPattern(String input) => _fromPattern(input.runes.toList());

CharMatcher _fromPattern(List<int> pattern) {
  // Negation: ^pattern.
  final isNegated = pattern.isNotEmpty && _negateMatcher.match(pattern[0]);
  if (isNegated) pattern = pattern.sublist(1);

  final ranges = <RangeCharMatcher>[];
  while (pattern.isNotEmpty) {
    if (ranges.isNotEmpty &&
        pattern.length > 2 &&
        _rangeMatcher.match(pattern[0]) &&
        _openMatcher.match(pattern[1]) &&
        _closeMatcher.match(pattern.last)) {
      // Subtraction: base-[subtract]
      final base = _completePattern(ranges, isNegated);
      final subtract = _fromPattern(pattern.sublist(2, pattern.length - 1));
      return base & ~subtract;
    } else if (pattern.length > 2 && _rangeMatcher.match(pattern[1])) {
      // Ranges: start-stop
      ranges.add(RangeCharMatcher(pattern[0], pattern[2]));
      pattern = pattern.sublist(3);
    } else {
      // Single character
      ranges.add(RangeCharMatcher(pattern[0], pattern[0]));
      pattern = pattern.sublist(1);
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
