import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('blocks', () {
    test('basicLatin', () {
      check(UnicodeBlockCharMatcher.basicLatin.match(0x0000)).isTrue();
      check(UnicodeBlockCharMatcher.basicLatin.match(0x007f)).isTrue();
      check(UnicodeBlockCharMatcher.basicLatin.match(0x0080)).isFalse();
    });
    test('latin1Supplement', () {
      check(UnicodeBlockCharMatcher.latin1Supplement.match(0x007f)).isFalse();
      check(UnicodeBlockCharMatcher.latin1Supplement.match(0x0080)).isTrue();
      check(UnicodeBlockCharMatcher.latin1Supplement.match(0x00ff)).isTrue();
      check(UnicodeBlockCharMatcher.latin1Supplement.match(0x0100)).isFalse();
    });
    test('greekAndCoptic', () {
      check(UnicodeBlockCharMatcher.greekAndCoptic.match(0x0370)).isTrue();
      check(UnicodeBlockCharMatcher.greekAndCoptic.match(0x03ff)).isTrue();
      check(UnicodeBlockCharMatcher.greekAndCoptic.match(0x0400)).isFalse();
    });
    test('cyrillic', () {
      check(UnicodeBlockCharMatcher.cyrillic.match(0x0400)).isTrue();
      check(UnicodeBlockCharMatcher.cyrillic.match(0x04ff)).isTrue();
      check(UnicodeBlockCharMatcher.cyrillic.match(0x0500)).isFalse();
    });
  });
}
