import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:more/printer.dart';

void verify(
  CharMatcher matcher,
  String included,
  String excluded, {
  bool negate = true,
}) {
  // Test inclusion and exclusion.
  for (final iterator = included.runes.iterator; iterator.moveNext();) {
    check(
      matcher(iterator.current),
      because: '${unicodeCodePointPrinter(iterator.current)} should match',
    ).isTrue();
  }
  for (final iterator = excluded.runes.iterator; iterator.moveNext();) {
    check(
      matcher(iterator.current),
      because: '${unicodeCodePointPrinter(iterator.current)} should not match',
    ).isFalse();
  }
  // Test basic operators.
  check(
    matcher.everyOf(included),
    because: 'all of "$included" should match',
  ).isTrue();
  check(
    matcher.noneOf(excluded),
    because: 'none of "$excluded" should match',
  ).isTrue();
  check(matcher.countIn(included)).equals(included.runes.length);
  check(matcher.replaceFrom(included, '')).equals('');
  check(matcher.removeFrom(included)).equals('');
  check(matcher.retainFrom(included)).equals(included);
  check(matcher.trimLeadingFrom(included)).equals('');
  check(matcher.trimTailingFrom(included)).equals('');
  check(matcher.toString()).startsWith(matcher.runtimeType.toString());
  // Negated version of the matcher.
  if (negate) verify(~matcher, excluded, included, negate: false);
}
