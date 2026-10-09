import 'package:checks/checks.dart';
import 'package:more/src/char_matcher/unicode/blocks.dart' as blocks;
import 'package:test/scaffolding.dart';

void main() {
  group('blocks', () {
    test('basicLatin', () {
      check(blocks.basicLatin.match(0x0000)).isTrue();
      check(blocks.basicLatin.match(0x007f)).isTrue();
      check(blocks.basicLatin.match(0x0080)).isFalse();
    });
    test('latin1Supplement', () {
      check(blocks.latin1Supplement.match(0x007f)).isFalse();
      check(blocks.latin1Supplement.match(0x0080)).isTrue();
      check(blocks.latin1Supplement.match(0x00ff)).isTrue();
      check(blocks.latin1Supplement.match(0x0100)).isFalse();
    });
    test('greekAndCoptic', () {
      check(blocks.greekAndCoptic.match(0x0370)).isTrue();
      check(blocks.greekAndCoptic.match(0x03ff)).isTrue();
      check(blocks.greekAndCoptic.match(0x0400)).isFalse();
    });
    test('cyrillic', () {
      check(blocks.cyrillic.match(0x0400)).isTrue();
      check(blocks.cyrillic.match(0x04ff)).isTrue();
      check(blocks.cyrillic.match(0x0500)).isFalse();
    });
  });
}
