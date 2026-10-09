import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('pattern', () {
    test('empty', () {
      verify(CharMatcher.pattern(''), '', 'abc');
    });
    test('single', () {
      verify(CharMatcher.pattern('a'), 'a', 'b');
    });
    test('many single', () {
      verify(CharMatcher.pattern('abc'), 'abc', 'd');
    });
    test('range', () {
      verify(CharMatcher.pattern('a-c'), 'abc', 'd');
    });
    test('overlapping range', () {
      verify(CharMatcher.pattern('b-da-c'), 'abcd', 'e');
    });
    test('adjacent range', () {
      verify(CharMatcher.pattern('c-ea-c'), 'abcde', 'f');
    });
    test('prefix range', () {
      verify(CharMatcher.pattern('a-ea-c'), 'abcde', 'f');
    });
    test('postfix range', () {
      verify(CharMatcher.pattern('a-ec-e'), 'abcde', 'f');
    });
    test('repeated range', () {
      verify(CharMatcher.pattern('a-ea-e'), 'abcde', 'f');
    });
    test('composed range', () {
      verify(CharMatcher.pattern('ac-df-'), 'acdf-', 'beg');
    });
    test('negated single', () {
      verify(CharMatcher.pattern('^a'), 'b', 'a');
    });
    test('negated range', () {
      verify(CharMatcher.pattern('^a-c'), 'd', 'abc');
    });
    test('negated composed', () {
      verify(CharMatcher.pattern('^ac-df-'), 'beg', 'acdf-');
    });
    test('full range', () {
      verify(CharMatcher.pattern('\u0000-\uffff'), '\u0000\u7777\uffff', '');
    });
    test('large range', () {
      verify(
        CharMatcher.pattern('\u2200-\u22ff\u27c0-\u27ef\u2980-\u29ff'),
        '∉⟃⦻',
        'a',
      );
    });
    test('far range', () {
      verify(
        CharMatcher.pattern('\u0000\uffff'),
        '\u0000\uffff',
        '\u0001\ufffe',
      );
    });
    test('class subtraction', () {
      verify(
        CharMatcher.pattern('a-z-[aeiuo]'),
        'bcdfghjklmnpqrstvwxyz',
        '123aeiuo',
      );
      verify(CharMatcher.pattern('^1234-[3456]'), 'abc7890', '123456');
      verify(CharMatcher.pattern('0-9-[0-6-[0-3]]'), '0123789', 'abc456');
    });
  });
}
