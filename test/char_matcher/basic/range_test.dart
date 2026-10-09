import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/basic/range.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('range', () {
    test('inRange', () {
      verify(CharMatcher.inRange('a', 'c'), 'abc', 'def123_!@# ');
    });
    test('inRange (code points)', () {
      verify(CharMatcher.inRange(97, 99), 'abc', 'def123_!@# ');
    });
    test('assert error', () {
      check(() => RangeCharMatcher(100, 50)).throws<AssertionError>();
    });
  });
}
