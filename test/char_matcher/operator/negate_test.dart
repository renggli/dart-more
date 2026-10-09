import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('negate', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    const whitespace = CharMatcher.whitespace();
    test('inversion', () {
      check(~any).equals(none);
      check(~none).equals(any);
      check(~~whitespace).equals(whitespace);
    });
    test('match', () {
      verify(~whitespace, 'abcABC_!@#\u0000', '\t\n\r\v\f ');
    });
  });
}
