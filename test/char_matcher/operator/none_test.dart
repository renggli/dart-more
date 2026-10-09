import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('none', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const letter = CharMatcher.letter();
    test('match', () {
      verify(none, '', 'abc123_!@# 💩');
      verify(none, '', '👱🧑🏼');
    });
    test('negation', () {
      check(~none).equals(any);
    });
    test('disjunction', () {
      check(none | letter).equals(letter);
      check(letter | none).equals(letter);
    });
    test('conjunction', () {
      check(none & letter).equals(none);
      check(letter & none).equals(none);
    });
  });
}
