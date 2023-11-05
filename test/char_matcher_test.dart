// ignore_for_file: deprecated_member_use_from_same_package

import 'package:more/char_matcher.dart';
import 'package:test/test.dart';

void verify(CharMatcher matcher, String included, String excluded,
    {bool negate = true}) {
  for (final iterator = included.runes.iterator; iterator.moveNext();) {
    expect(matcher.match(iterator.current), isTrue,
        reason: '${iterator.currentAsString} should match');
  }
  for (final iterator = excluded.runes.iterator; iterator.moveNext();) {
    expect(matcher.match(iterator.current), isFalse,
        reason: '${iterator.currentAsString} should not match');
  }
  expect(matcher.everyOf(included), isTrue,
      reason: 'all of "$included" should match');
  expect(matcher.noneOf(excluded), isTrue,
      reason: 'none of "$excluded" should match');
  if (negate) verify(~matcher, excluded, included, negate: false);
}

void main() {
  group('basic', () {
    test('any', () {
      verify(const CharMatcher.any(), 'abc123_!@# 💩', '');
      verify(const CharMatcher.any(), '👱🧑🏼', '');
    });
    test('none', () {
      verify(const CharMatcher.none(), '', 'abc123_!@# 💩');
      verify(const CharMatcher.none(), '', '👱🧑🏼');
    });
    test('isChar', () {
      verify(CharMatcher.isChar('*'), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar('👱'), '👱', 'abc123_!@# 💩');
    });
    test('isChar number', () {
      verify(CharMatcher.isChar(42), '*', 'abc123_!@# ');
      verify(CharMatcher.isChar(42.0), '*', 'abc123_!@# ');
    });
    test('isChar invalid', () {
      expect(() => CharMatcher.isChar('ab'), throwsArgumentError,
          reason: 'multiple characters');
      expect(() => CharMatcher.isChar('🧑🏼'), throwsArgumentError,
          reason: 'composite emoji');
    });
    test('inRange', () {
      verify(CharMatcher.inRange('a', 'c'), 'abc', 'def123_!@# ');
    });
    test('ascii', () {
      verify(const CharMatcher.ascii(), 'def123_!@#', '\u2665');
    });
    test('digit', () {
      verify(const CharMatcher.digit(), '0123456789', 'abc_!@# ');
    });
    test('letter', () {
      verify(CharMatcher.letter(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '123_!@# ');
    });
    test('lowerCaseLetter', () {
      verify(CharMatcher.lowerCaseLetter(), 'abcdefghijklmnopqrstuvwxyz',
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ123_!@# ');
    });
    test('upperCaseLetter', () {
      verify(CharMatcher.upperCaseLetter(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz123_!@# ');
    });
    test('letterOrDigit', () {
      verify(
          const CharMatcher.letterOrDigit(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_',
          '!@# ');
    });
    test('whitespace', () {
      final string = String.fromCharCodes([
        9,
        10,
        11,
        12,
        13,
        32,
        133,
        160,
        5760,
        8192,
        8193,
        8194,
        8195,
        8196,
        8197,
        8198,
        8199,
        8200,
        8201,
        8202,
        8232,
        8233,
        8239,
        8287,
        12288,
      ]);
      verify(const CharMatcher.whitespace(), string, 'abcABC_!@#\u0000');
    });
  });
  group('char set', () {
    test('empty', () {
      verify(CharMatcher.charSet(''), '', 'abc');
    });
    test('single', () {
      verify(CharMatcher.charSet('b'), 'b', 'ac');
    });
    test('many single', () {
      verify(CharMatcher.charSet('bcd'), 'bcd', 'ae');
      verify(CharMatcher.charSet('dcb'), 'bcd', 'ae');
    });
    test('many separate', () {
      verify(CharMatcher.charSet('bdf'), 'bdf', 'aceg');
      verify(CharMatcher.charSet('fdb'), 'bdf', 'aceg');
    });
    test('special chars', () {
      verify(CharMatcher.charSet('^a-z'), '^-az', 'by');
    });
  });
  group('patterns', () {
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
      verify(CharMatcher.pattern('\u2200-\u22ff\u27c0-\u27ef\u2980-\u29ff'),
          '∉⟃⦻', 'a');
    });
    test('far range', () {
      verify(
          CharMatcher.pattern('\u0000\uffff'), '\u0000\uffff', '\u0001\ufffe');
    });
    test('class subtraction', () {
      verify(CharMatcher.pattern('a-z-[aeiuo]'), 'bcdfghjklmnpqrstvwxyz',
          '123aeiuo');
      verify(CharMatcher.pattern('^1234-[3456]'), 'abc7890', '123456');
      verify(CharMatcher.pattern('0-9-[0-6-[0-3]]'), '0123789', 'abc456');
    });
  });
  group('operators', () {
    const any = CharMatcher.any();
    const none = CharMatcher.none();
    final letter = CharMatcher.letter();
    const digit = CharMatcher.digit();
    const whitespace = CharMatcher.whitespace();
    final hex = CharMatcher.pattern('0-9a-f');
    final even = CharMatcher.pattern('02468');
    test('~ (negation)', () {
      expect(~any, equals(none));
      expect(~none, equals(any));
      expect(~~whitespace, equals(whitespace));
    });
    test('| (disjunctive)', () {
      expect(any | letter, equals(any));
      expect(letter | any, equals(any));
      expect(none | letter, equals(letter));
      expect(letter | none, equals(letter));
      verify(letter | digit, 'abc123', '_!@# ');
      verify(digit | letter, 'abc123', '_!@# ');
      verify(letter | digit | whitespace, 'abc123 ', '_!@#');
      verify(letter | (digit | whitespace), 'abc123 ', '_!@#');
      verify((letter | digit) | whitespace, 'abc123 ', '_!@#');
      verify((letter | digit) | (whitespace | digit), 'abc123 ', '_!@#');
    });
    test('& (conjunctive)', () {
      expect(any & letter, equals(letter));
      expect(letter & any, equals(letter));
      expect(none & letter, equals(none));
      expect(letter & none, equals(none));
      verify(hex & letter, 'abcdef', '012_!@# ');
      verify(letter & hex, 'abcdef', '012_!@# ');
      verify(hex & digit & even, '0248', 'abc13_!@# ');
      verify(hex & (digit & even), '0248', 'abc13_!@# ');
      verify((hex & digit) & even, '0248', 'abc13_!@# ');
    });
  });
  group('action', () {
    final star = CharMatcher.isChar('*');
    test('anyOf', () {
      expect(star.anyOf(''), isFalse);
      expect(star.anyOf('a'), isFalse);
      expect(star.anyOf('*'), isTrue);
      expect(star.anyOf('ab'), isFalse);
      expect(star.anyOf('a*'), isTrue);
      expect(star.anyOf('*b'), isTrue);
      expect(star.anyOf('**'), isTrue);
    });
    test('everyOf', () {
      expect(star.everyOf(''), isTrue);
      expect(star.everyOf('a'), isFalse);
      expect(star.everyOf('*'), isTrue);
      expect(star.everyOf('ab'), isFalse);
      expect(star.everyOf('a*'), isFalse);
      expect(star.everyOf('*b'), isFalse);
      expect(star.everyOf('**'), isTrue);
    });

    test('noneOf', () {
      expect(star.noneOf(''), isTrue);
      expect(star.noneOf('a'), isTrue);
      expect(star.noneOf('*'), isFalse);
      expect(star.noneOf('ab'), isTrue);
      expect(star.noneOf('a*'), isFalse);
      expect(star.noneOf('*b'), isFalse);
      expect(star.noneOf('**'), isFalse);
    });
    test('firstIndexIn', () {
      expect(star.firstIndexIn(''), -1);
      expect(star.firstIndexIn('*'), 0);
      expect(star.firstIndexIn('**'), 0);
      expect(star.firstIndexIn('a'), -1);
      expect(star.firstIndexIn('a*'), 1);
      expect(star.firstIndexIn('a**'), 1);
      expect(star.firstIndexIn('*', 1), -1);
      expect(star.firstIndexIn('**', 1), 1);
    });
    test('lastIndexIn', () {
      expect(star.lastIndexIn(''), -1);
      expect(star.lastIndexIn('*'), 0);
      expect(star.lastIndexIn('**'), 1);
      expect(star.lastIndexIn('a'), -1);
      expect(star.lastIndexIn('*a'), 0);
      expect(star.lastIndexIn('**a'), 1);
      expect(star.lastIndexIn('*', 0), 0);
      expect(star.lastIndexIn('**', 0), 0);
    });
    test('countIn', () {
      expect(star.countIn(''), 0);
      expect(star.countIn('*'), 1);
      expect(star.countIn('**'), 2);
      expect(star.countIn('a'), 0);
      expect(star.countIn('ab'), 0);
      expect(star.countIn('a*b'), 1);
      expect(star.countIn('*a*b'), 2);
      expect(star.countIn('*a*b*'), 3);
    });
    test('collapseFrom', () {
      expect(star.collapseFrom('', ''), '');
      expect(star.collapseFrom('', '!'), '');
      expect(star.collapseFrom('', '!!'), '');
      expect(star.collapseFrom('*', ''), '');
      expect(star.collapseFrom('*', '!'), '!');
      expect(star.collapseFrom('*', '!!'), '!!');
      expect(star.collapseFrom('**', ''), '');
      expect(star.collapseFrom('**', '!'), '!');
      expect(star.collapseFrom('**', '!!'), '!!');
      expect(star.collapseFrom('*a*', ''), 'a');
      expect(star.collapseFrom('*a*', '!'), '!a!');
      expect(star.collapseFrom('*a*', '!!'), '!!a!!');
      expect(star.collapseFrom('**a**', ''), 'a');
      expect(star.collapseFrom('**a**', '!'), '!a!');
      expect(star.collapseFrom('**a**', '!!'), '!!a!!');
      expect(star.collapseFrom('a*b*c', ''), 'abc');
      expect(star.collapseFrom('a*b*c', '!'), 'a!b!c');
      expect(star.collapseFrom('a*b*c', '!!'), 'a!!b!!c');
      expect(star.collapseFrom('a**b**c', ''), 'abc');
      expect(star.collapseFrom('a**b**c', '!'), 'a!b!c');
      expect(star.collapseFrom('a**b**c', '!!'), 'a!!b!!c');
    });
    test('replaceFrom', () {
      expect(star.replaceFrom('', ''), '');
      expect(star.replaceFrom('', '!'), '');
      expect(star.replaceFrom('', '!!'), '');
      expect(star.replaceFrom('*', ''), '');
      expect(star.replaceFrom('*', '!'), '!');
      expect(star.replaceFrom('*', '!!'), '!!');
      expect(star.replaceFrom('**', ''), '');
      expect(star.replaceFrom('**', '!'), '!!');
      expect(star.replaceFrom('**', '!!'), '!!!!');
      expect(star.replaceFrom('*a*', ''), 'a');
      expect(star.replaceFrom('*a*', '!'), '!a!');
      expect(star.replaceFrom('*a*', '!!'), '!!a!!');
      expect(star.replaceFrom('**a**', ''), 'a');
      expect(star.replaceFrom('**a**', '!'), '!!a!!');
      expect(star.replaceFrom('**a**', '!!'), '!!!!a!!!!');
      expect(star.replaceFrom('a*b*c', ''), 'abc');
      expect(star.replaceFrom('a*b*c', '!'), 'a!b!c');
      expect(star.replaceFrom('a*b*c', '!!'), 'a!!b!!c');
      expect(star.replaceFrom('a**b**c', ''), 'abc');
      expect(star.replaceFrom('a**b**c', '!'), 'a!!b!!c');
      expect(star.replaceFrom('a**b**c', '!!'), 'a!!!!b!!!!c');
    });
    test('removeFrom', () {
      expect(star.removeFrom(''), '');
      expect(star.removeFrom('*'), '');
      expect(star.removeFrom('**'), '');
      expect(star.removeFrom('*a'), 'a');
      expect(star.removeFrom('*a*'), 'a');
      expect(star.removeFrom('*a*b'), 'ab');
      expect(star.removeFrom('*a*b*'), 'ab');
      expect(star.removeFrom('a*b*'), 'ab');
      expect(star.removeFrom('ab*'), 'ab');
      expect(star.removeFrom('ab'), 'ab');
    });
    test('retainFrom', () {
      expect(star.retainFrom(''), '');
      expect(star.retainFrom('*'), '*');
      expect(star.retainFrom('**'), '**');
      expect(star.retainFrom('*a'), '*');
      expect(star.retainFrom('*a*'), '**');
      expect(star.retainFrom('*a*b'), '**');
      expect(star.retainFrom('*a*b*'), '***');
      expect(star.retainFrom('a*b*'), '**');
      expect(star.retainFrom('ab*'), '*');
      expect(star.retainFrom('ab'), '');
    });
    test('trimFrom', () {
      expect(star.trimFrom(''), '');
      expect(star.trimFrom('*'), '');
      expect(star.trimFrom('**'), '');
      expect(star.trimFrom('*a'), 'a');
      expect(star.trimFrom('**a'), 'a');
      expect(star.trimFrom('*ab'), 'ab');
      expect(star.trimFrom('a*'), 'a');
      expect(star.trimFrom('a**'), 'a');
      expect(star.trimFrom('ab*'), 'ab');
      expect(star.trimFrom('*a*'), 'a');
      expect(star.trimFrom('**a**'), 'a');
      expect(star.trimFrom('*ab*'), 'ab');
    });
    test('trimLeadingFrom', () {
      expect(star.trimLeadingFrom(''), '');
      expect(star.trimLeadingFrom('*'), '');
      expect(star.trimLeadingFrom('**'), '');
      expect(star.trimLeadingFrom('*a'), 'a');
      expect(star.trimLeadingFrom('**a'), 'a');
      expect(star.trimLeadingFrom('*ab'), 'ab');
      expect(star.trimLeadingFrom('a*'), 'a*');
      expect(star.trimLeadingFrom('a**'), 'a**');
      expect(star.trimLeadingFrom('ab*'), 'ab*');
      expect(star.trimLeadingFrom('*a*'), 'a*');
      expect(star.trimLeadingFrom('**a**'), 'a**');
      expect(star.trimLeadingFrom('*ab*'), 'ab*');
    });
    test('trimTailingFrom', () {
      expect(star.trimTailingFrom(''), '');
      expect(star.trimTailingFrom('*'), '');
      expect(star.trimTailingFrom('**'), '');
      expect(star.trimTailingFrom('*a'), '*a');
      expect(star.trimTailingFrom('**a'), '**a');
      expect(star.trimTailingFrom('*ab'), '*ab');
      expect(star.trimTailingFrom('a*'), 'a');
      expect(star.trimTailingFrom('a**'), 'a');
      expect(star.trimTailingFrom('ab*'), 'ab');
      expect(star.trimTailingFrom('*a*'), '*a');
      expect(star.trimTailingFrom('**a**'), '**a');
      expect(star.trimTailingFrom('*ab*'), '*ab');
    });
  });
  group('pattern', () {
    const input = 'a1b2c';
    const pattern = CharMatcher.digit();
    test('allMatches()', () {
      final matches = pattern.allMatches(input);
      expect(matches.map((matcher) => matcher.pattern), [pattern, pattern]);
      expect(matches.map((matcher) => matcher.input), [input, input]);
      expect(matches.map((matcher) => matcher.start), [1, 3]);
      expect(matches.map((matcher) => matcher.end), [2, 4]);
      expect(matches.map((matcher) => matcher.groupCount), [0, 0]);
      expect(matches.map((matcher) => matcher[0]), ['1', '2']);
      expect(matches.map((matcher) => matcher.group(0)), ['1', '2']);
      expect(matches.map((matcher) => matcher.groups([0, 1])), [
        ['1', null],
        ['2', null],
      ]);
    });
    test('matchAsPrefix()', () {
      final match1 = pattern.matchAsPrefix(input);
      expect(match1, isNull);
      final match2 = pattern.matchAsPrefix(input, 1)!;
      expect(match2.pattern, pattern);
      expect(match2.input, input);
      expect(match2.start, 1);
      expect(match2.end, 2);
      expect(match2.groupCount, 0);
      expect(match2[0], '1');
      expect(match2.group(0), '1');
      expect(match2.groups([0, 1]), ['1', null]);
    });
    test('startsWith()', () {
      expect(input.startsWith(pattern), isFalse);
      expect(input.startsWith(pattern), isFalse);
      expect(input.startsWith(pattern, 1), isTrue);
      expect(input.startsWith(pattern, 2), isFalse);
      expect(input.startsWith(pattern, 3), isTrue);
      expect(input.startsWith(pattern, 4), isFalse);
    });
    test('indexOf()', () {
      expect(input.indexOf(pattern), 1);
      expect(input.indexOf(pattern), 1);
      expect(input.indexOf(pattern, 1), 1);
      expect(input.indexOf(pattern, 2), 3);
      expect(input.indexOf(pattern, 3), 3);
      expect(input.indexOf(pattern, 4), -1);
    });
    test('lastIndexOf()', () {
      expect(input.lastIndexOf(pattern), 3);
      expect(input.lastIndexOf(pattern, 0), -1);
      expect(input.lastIndexOf(pattern, 1), 1);
      expect(input.lastIndexOf(pattern, 2), 1);
      expect(input.lastIndexOf(pattern, 3), 3);
      expect(input.lastIndexOf(pattern, 4), 3);
    });
    test('contains()', () {
      expect(input.contains(pattern), isTrue);
    });
    test('replaceFirst()', () {
      expect(input.replaceFirst(pattern, '!'), 'a!b2c');
      expect(input.replaceFirst(pattern, '!'), 'a!b2c');
      expect(input.replaceFirst(pattern, '!', 1), 'a!b2c');
      expect(input.replaceFirst(pattern, '!', 2), 'a1b!c');
      expect(input.replaceFirst(pattern, '!', 3), 'a1b!c');
      expect(input.replaceFirst(pattern, '!', 4), 'a1b2c');
    });
    test('replaceFirstMapped()', () {
      expect(input.replaceFirstMapped(pattern, (match) => '!${match[0]}!'),
          'a!1!b2c');
    });
    test('replaceAll()', () {
      expect(input.replaceAll(pattern, '!'), 'a!b!c');
    }, onPlatform: {
      'js': const Skip('String.replaceAll(Pattern) UNIMPLEMENTED')
    });
    test('replaceAllMapped()', () {
      expect(input.replaceAllMapped(pattern, (match) => '!${match[0]}!'),
          'a!1!b!2!c');
    });
    test('split()', () {
      expect(input.split(pattern), ['a', 'b', 'c']);
    });
    test('splitMapJoin()', () {
      expect(
          input.splitMapJoin(pattern,
              onMatch: (match) => '!${match[0]}!',
              onNonMatch: (nonMatch) => '?$nonMatch?'),
          '?a?!1!?b?!2!?c?');
    });
  });
}
