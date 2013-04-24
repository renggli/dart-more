// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library char_matcher_test;

import 'package:unittest/unittest.dart';
import 'package:more/char_matcher.dart';

void verify(CharMatcher matcher, String included, String excluded) {
  var positive = matcher;
  expect(positive.matchesEvery(included), isTrue);
  expect(positive.matchesAny(excluded), isFalse);
  var negative = ~matcher;
  expect(negative.matchesEvery(excluded), isTrue);
  expect(negative.matchesAny(included), isFalse);
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
    group('action', () {
      var star = isChar('*');
      test('matchesEvery', () {
        expect(star.matchesEvery(''), isTrue);
        expect(star.matchesEvery('a'), isFalse);
        expect(star.matchesEvery('*'), isTrue);
        expect(star.matchesEvery('ab'), isFalse);
        expect(star.matchesEvery('a*'), isFalse);
        expect(star.matchesEvery('*b'), isFalse);
        expect(star.matchesEvery('**'), isTrue);
      });
      test('matchesAny', () {
        expect(star.matchesAny(''), isFalse);
        expect(star.matchesAny('a'), isFalse);
        expect(star.matchesAny('*'), isTrue);
        expect(star.matchesAny('ab'), isFalse);
        expect(star.matchesAny('a*'), isTrue);
        expect(star.matchesAny('*b'), isTrue);
        expect(star.matchesAny('**'), isTrue);
      });
      test('firstIndex', () {
        expect(star.firstIndex(''), -1);
        expect(star.firstIndex('*'), 0);
        expect(star.firstIndex('**'), 0);
        expect(star.firstIndex('a'), -1);
        expect(star.firstIndex('a*'), 1);
        expect(star.firstIndex('a**'), 1);
        expect(star.firstIndex('*', 1), -1);
        expect(star.firstIndex('**', 1), 1);
      });
      test('lastIndex', () {
        expect(star.lastIndex(''), -1);
        expect(star.lastIndex('*'), 0);
        expect(star.lastIndex('**'), 1);
        expect(star.lastIndex('a'), -1);
        expect(star.lastIndex('*a'), 0);
        expect(star.lastIndex('**a'), 1);
        expect(star.lastIndex('*', 0), 0);
        expect(star.lastIndex('**', 0), 0);
      });
      test('count', () {
        expect(star.count(''), 0);
        expect(star.count('*'), 1);
        expect(star.count('**'), 2);
        expect(star.count('a'), 0);
        expect(star.count('ab'), 0);
        expect(star.count('a*b'), 1);
        expect(star.count('*a*b'), 2);
        expect(star.count('*a*b*'), 3);
      });
      test('collapse', () {
        expect(star.collapse('', ''), '');
        expect(star.collapse('', '!'), '');
        expect(star.collapse('', '!!'), '');
        expect(star.collapse('*', ''), '');
        expect(star.collapse('*', '!'), '!');
        expect(star.collapse('*', '!!'), '!!');
        expect(star.collapse('**', ''), '');
        expect(star.collapse('**', '!'), '!');
        expect(star.collapse('**', '!!'), '!!');
        expect(star.collapse('a*b*c', ''), 'abc');
        expect(star.collapse('a*b*c', '!'), 'a!b!c');
        expect(star.collapse('a*b*c', '!!'), 'a!!b!!c');
        expect(star.collapse('a**b**c', ''), 'abc');
        expect(star.collapse('a**b**c', '!'), 'a!b!c');
        expect(star.collapse('a**b**c', '!!'), 'a!!b!!c');
      });
      test('replace', () {
        expect(star.replace('', ''), '');
        expect(star.replace('', '!'), '');
        expect(star.replace('', '!!'), '');
        expect(star.replace('*', ''), '');
        expect(star.replace('*', '!'), '!');
        expect(star.replace('*', '!!'), '!!');
        expect(star.replace('**', ''), '');
        expect(star.replace('**', '!'), '!!');
        expect(star.replace('**', '!!'), '!!!!');
        expect(star.replace('a*b*c', ''), 'abc');
        expect(star.replace('a*b*c', '!'), 'a!b!c');
        expect(star.replace('a*b*c', '!!'), 'a!!b!!c');
        expect(star.replace('a**b**c', ''), 'abc');
        expect(star.replace('a**b**c', '!'), 'a!!b!!c');
        expect(star.replace('a**b**c', '!!'), 'a!!!!b!!!!c');
      });
      test('remove', () {
        expect(star.remove(''), '');
        expect(star.remove('*'), '');
        expect(star.remove('**'), '');
        expect(star.remove('*a'), 'a');
        expect(star.remove('*a*'), 'a');
        expect(star.remove('*a*b'), 'ab');
        expect(star.remove('*a*b*'), 'ab');
        expect(star.remove('a*b*'), 'ab');
        expect(star.remove('ab*'), 'ab');
        expect(star.remove('ab'), 'ab');
      });
      test('retain', () {
        expect(star.retain(''), '');
        expect(star.retain('*'), '*');
        expect(star.retain('**'), '**');
        expect(star.retain('*a'), '*');
        expect(star.retain('*a*'), '**');
        expect(star.retain('*a*b'), '**');
        expect(star.retain('*a*b*'), '***');
        expect(star.retain('a*b*'), '**');
        expect(star.retain('ab*'), '*');
        expect(star.retain('ab'), '');
      });
      test('trim', () {
        expect(star.trim(''), '');
        expect(star.trim('*'), '');
        expect(star.trim('**'), '');
        expect(star.trim('*a'), 'a');
        expect(star.trim('**a'), 'a');
        expect(star.trim('*ab'), 'ab');
        expect(star.trim('a*'), 'a');
        expect(star.trim('a**'), 'a');
        expect(star.trim('ab*'), 'ab');
        expect(star.trim('*a*'), 'a');
        expect(star.trim('**a**'), 'a');
        expect(star.trim('*ab*'), 'ab');
      });
      test('trimLeft', () {
        expect(star.trimLeft(''), '');
        expect(star.trimLeft('*'), '');
        expect(star.trimLeft('**'), '');
        expect(star.trimLeft('*a'), 'a');
        expect(star.trimLeft('**a'), 'a');
        expect(star.trimLeft('*ab'), 'ab');
        expect(star.trimLeft('a*'), 'a*');
        expect(star.trimLeft('a**'), 'a**');
        expect(star.trimLeft('ab*'), 'ab*');
        expect(star.trimLeft('*a*'), 'a*');
        expect(star.trimLeft('**a**'), 'a**');
        expect(star.trimLeft('*ab*'), 'ab*');
      });
      test('trimRight', () {
        expect(star.trimRight(''), '');
        expect(star.trimRight('*'), '');
        expect(star.trimRight('**'), '');
        expect(star.trimRight('*a'), '*a');
        expect(star.trimRight('**a'), '**a');
        expect(star.trimRight('*ab'), '*ab');
        expect(star.trimRight('a*'), 'a');
        expect(star.trimRight('a**'), 'a');
        expect(star.trimRight('ab*'), 'ab');
        expect(star.trimRight('*a*'), '*a');
        expect(star.trimRight('**a**'), '**a');
        expect(star.trimRight('*ab*'), '*ab');
      });
    });
  });
}