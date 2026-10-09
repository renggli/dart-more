import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('disjunctive', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const letter = CharMatcher.letter();
    const digit = CharMatcher.digit();
    const whitespace = CharMatcher.whitespace();
    test('identity and absorption', () {
      check(any | letter).equals(any);
      check(letter | any).equals(any);
      check(none | letter).equals(letter);
      check(letter | none).equals(letter);
    });
    test('disjunction match', () {
      verify(letter | digit, 'abc123', '_!@# ');
      verify(digit | letter, 'abc123', '_!@# ');
      verify(letter | digit | whitespace, 'abc123 ', '_!@#');
      verify(letter | (digit | whitespace), 'abc123 ', '_!@#');
      verify((letter | digit) | whitespace, 'abc123 ', '_!@#');
      verify((letter | digit) | (whitespace | digit), 'abc123 ', '_!@#');
    });
  });
}
