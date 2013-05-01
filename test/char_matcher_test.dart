// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library char_matcher_test;

import 'package:unittest/unittest.dart';
import 'package:more/char_matcher.dart';

void verify(CharMatcher matcher, String included, String excluded) {
  var positive = matcher;
  expect(positive.everyOf(included), isTrue);
  expect(positive.anyOf(excluded), isFalse);
  var negative = ~matcher;
  expect(negative.everyOf(excluded), isTrue);
  expect(negative.anyOf(included), isFalse);
}

void main() {
  group('char matcher', () {
    group('class', () {
      test('ANY', () {
        verify(ANY, 'abc123!@#', '');
      });
      test('NONE', () {
        verify(NONE, '', 'abc123!@# ');
      });
      test('isChar', () {
        verify(isChar('*'), '*', 'abc123!@# ');
      });
      test('inRange', () {
        verify(inRange('a', 'c'), 'abc', 'def123!@# ');
      });
      test('ASCII', () {
        verify(ASCII, 'def123!@#', '\u2665');
      });
      test('DIGIT', () {
        verify(DIGIT, '0123456789', 'abc!@# ');
      });
      test('LETTER', () {
        verify(LETTER, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '123!@# ');
      });
      test('LOWER_CASE_LETTER', () {
        verify(LOWER_CASE_LETTER, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123!@# ');
      });
      test('UPPER_CASE_LETTER', () {
        verify(UPPER_CASE_LETTER, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz123!@# ');
      });
      test('LETTER_OR_DIGIT', () {
        verify(LETTER_OR_DIGIT, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890', '!@# ');
      });
      test('WHITESPACE', () {
        verify(WHITESPACE, ' \n\t', 'abcABC!@#');
      });
    });
    group('operators', () {
      test('~', () {
        expect(~ANY, equals(NONE));
        expect(~NONE, equals(ANY));
        expect(~~WHITESPACE, equals(WHITESPACE));
      });
      test('|', () {
        expect(ANY | LETTER, equals(ANY));
        expect(LETTER | ANY, equals(ANY));
        expect(NONE | LETTER, equals(LETTER));
        expect(LETTER | NONE, equals(LETTER));
        verify(LETTER | DIGIT, 'abc123', '!@# ');
        verify(DIGIT | LETTER, 'abc123', '!@# ');
        verify(LETTER | DIGIT | WHITESPACE, 'abc123 ', '!@#');
        verify(LETTER | (DIGIT | WHITESPACE), 'abc123 ', '!@#');
        verify((LETTER | DIGIT) | WHITESPACE, 'abc123 ', '!@#');
      });
      test('toString', () {
        expect(ANY.toString(), 'ANY');
        expect(NONE.toString(), 'NONE');
        expect(isChar('*').toString(), 'isChar("*")');
        expect(inRange('a', 'c').toString(), 'inRange("a", "c")');
        expect(ASCII.toString(), 'ASCII');
        expect(DIGIT.toString(), 'DIGIT');
        expect(LETTER.toString(), 'LETTER');
        expect(LOWER_CASE_LETTER.toString(), 'LOWER_CASE_LETTER');
        expect(UPPER_CASE_LETTER.toString(), 'UPPER_CASE_LETTER');
        expect(LETTER_OR_DIGIT.toString(), 'LETTER_OR_DIGIT');
        expect(WHITESPACE.toString(), 'WHITESPACE');
        expect((~WHITESPACE).toString(), '~WHITESPACE');
        expect((LETTER | DIGIT).toString(), 'LETTER | DIGIT');
      });
    });
    group('action', () {
      var star = isChar('*');
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
  });
}