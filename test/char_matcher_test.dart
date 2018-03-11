library more.test.char_matcher_test;

import 'package:more/char_matcher.dart';
import 'package:test/test.dart';

void verify(CharMatcher matcher, String included, String excluded) {
  var positive = matcher;
  expect(positive.everyOf(included), isTrue);
  expect(positive.anyOf(excluded), isFalse);
  var negative = ~matcher;
  expect(negative.everyOf(excluded), isTrue);
  expect(negative.anyOf(included), isFalse);
}

void main() {
  group('basic', () {
    test('any', () {
      verify(new CharMatcher.any(), 'abc123_!@#', '');
    });
    test('none', () {
      verify(new CharMatcher.none(), '', 'abc123_!@# ');
    });
    test('isChar', () {
      verify(new CharMatcher.isChar('*'), '*', 'abc123_!@# ');
    });
    test('isChar number', () {
      verify(new CharMatcher.isChar(42), '*', 'abc123_!@# ');
    });
    test('isChar invalid', () {
      expect(() => new CharMatcher.isChar('ab'), throwsArgumentError);
    });
    test('inRange', () {
      verify(new CharMatcher.inRange('a', 'c'), 'abc', 'def123_!@# ');
    });
    test('ascii', () {
      verify(new CharMatcher.ascii(), 'def123_!@#', '\u2665');
    });
    test('digit', () {
      verify(new CharMatcher.digit(), '0123456789', 'abc_!@# ');
    });
    test('letter', () {
      verify(new CharMatcher.letter(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '123_!@# ');
    });
    test('lowerCaseLetter', () {
      verify(new CharMatcher.lowerCaseLetter(), 'abcdefghijklmnopqrstuvwxyz',
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ123_!@# ');
    });
    test('upperCaseLetter', () {
      verify(new CharMatcher.upperCaseLetter(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz123_!@# ');
    });
    test('letterOrDigit', () {
      verify(
          new CharMatcher.letterOrDigit(),
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_',
          '!@# ');
    });
    test('whitespace', () {
      var string = new String.fromCharCodes([
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
        65279,
      ]);
      verify(new CharMatcher.whitespace(), string, 'abcABC_!@#\0');
    });
  });
  group('char set', () {
    test('empty', () {
      verify(new CharMatcher.charSet(''), '', 'abc');
    });
    test('single', () {
      verify(new CharMatcher.charSet('b'), 'b', 'ac');
    });
    test('many single', () {
      verify(new CharMatcher.charSet('bcd'), 'bcd', 'ae');
      verify(new CharMatcher.charSet('dcb'), 'bcd', 'ae');
    });
    test('many separate', () {
      verify(new CharMatcher.charSet('bdf'), 'bdf', 'aceg');
      verify(new CharMatcher.charSet('fdb'), 'bdf', 'aceg');
    });
    test('special chars', () {
      verify(new CharMatcher.charSet('^a-z'), '^-az', 'by');
    });
  });
  group('patterns', () {
    test('empty', () {
      verify(new CharMatcher.pattern(''), '', 'abc');
    });
    test('single', () {
      verify(new CharMatcher.pattern('a'), 'a', 'b');
    });
    test('many single', () {
      verify(new CharMatcher.pattern('abc'), 'abc', 'd');
    });
    test('range', () {
      verify(new CharMatcher.pattern('a-c'), 'abc', 'd');
    });
    test('overlapping range', () {
      verify(new CharMatcher.pattern('b-da-c'), 'abcd', 'e');
    });
    test('adjacent range', () {
      verify(new CharMatcher.pattern('c-ea-c'), 'abcde', 'f');
    });
    test('prefix range', () {
      verify(new CharMatcher.pattern('a-ea-c'), 'abcde', 'f');
    });
    test('postfix range', () {
      verify(new CharMatcher.pattern('a-ec-e'), 'abcde', 'f');
    });
    test('repeated range', () {
      verify(new CharMatcher.pattern('a-ea-e'), 'abcde', 'f');
    });
    test('composed range', () {
      verify(new CharMatcher.pattern('ac-df-'), 'acdf-', 'beg');
    });
    test('negated single', () {
      verify(new CharMatcher.pattern('^a'), 'b', 'a');
    });
    test('negated range', () {
      verify(new CharMatcher.pattern('^a-c'), 'd', 'abc');
    });
    test('negated composed', () {
      verify(new CharMatcher.pattern('^ac-df-'), 'beg', 'acdf-');
    });
    test('invalid order', () {
      expect(() => new CharMatcher.pattern('c-a'), throwsArgumentError);
    });
  });
  group('operators', () {
    var any = new CharMatcher.any();
    var none = new CharMatcher.none();
    var letter = new CharMatcher.letter();
    var digit = new CharMatcher.digit();
    var whitespace = new CharMatcher.whitespace();
    test('~', () {
      expect(~any, equals(none));
      expect(~none, equals(any));
      expect(~~whitespace, equals(whitespace));
    });
    test('|', () {
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
  });
  group('action', () {
    var star = new CharMatcher.isChar('*');
    test('everyOf', () {
      expect(star.everyOf(''), isTrue);
      expect(star.everyOf('a'), isFalse);
      expect(star.everyOf('*'), isTrue);
      expect(star.everyOf('ab'), isFalse);
      expect(star.everyOf('a*'), isFalse);
      expect(star.everyOf('*b'), isFalse);
      expect(star.everyOf('**'), isTrue);
    });
    test('anyOf', () {
      expect(star.anyOf(''), isFalse);
      expect(star.anyOf('a'), isFalse);
      expect(star.anyOf('*'), isTrue);
      expect(star.anyOf('ab'), isFalse);
      expect(star.anyOf('a*'), isTrue);
      expect(star.anyOf('*b'), isTrue);
      expect(star.anyOf('**'), isTrue);
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
}
