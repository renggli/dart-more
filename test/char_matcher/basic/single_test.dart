import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('single', () {
    test('isChar', () {
      verify(CharMatcher.isChar('*'), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar('👱'), '👱', 'abc123_!@# 💩');
    });
    test('isChar (code-point)', () {
      verify(CharMatcher.isChar(42), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar(42.0), '*', 'abc123_!@# ');
    });
    test('isChar (error)', () {
      check(() => CharMatcher.isChar('ab')).throws<ArgumentError>();
      check(() => CharMatcher.isChar('🧑🏼')).throws<ArgumentError>();
    });
  });
}
