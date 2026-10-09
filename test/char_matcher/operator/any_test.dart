import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('any', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const letter = CharMatcher.letter();
    test('match', () {
      verify(any, 'abc123_!@# 💩', '');
      verify(any, '👱🧑🏼', '');
    });
    test('negation', () {
      check(~any).equals(none);
    });
    test('disjunction', () {
      check(any | letter).equals(any);
      check(letter | any).equals(any);
    });
    test('conjunction', () {
      check(any & letter).equals(letter);
      check(letter & any).equals(letter);
    });
  });
}
