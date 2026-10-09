import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('conjunctive', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const letter = CharMatcher.letter();
    const digit = CharMatcher.digit();
    final hex = CharMatcher.pattern('0-9a-f');
    final even = CharMatcher.pattern('02468');
    test('identity and absorption', () {
      check(any & letter).equals(letter);
      check(letter & any).equals(letter);
      check(none & letter).equals(none);
      check(letter & none).equals(none);
    });
    test('conjunction match', () {
      verify(hex & letter, 'abcdef', '012_!@# ');
      verify(letter & hex, 'abcdef', '012_!@# ');
      verify(hex & digit & even, '0248', 'abc13_!@# ');
      verify(hex & (digit & even), '0248', 'abc13_!@# ');
      verify((hex & digit) & even, '0248', 'abc13_!@# ');
      verify((hex & digit) & (even & hex), '0248', 'abc13_!@# ');
    });
  });
}
