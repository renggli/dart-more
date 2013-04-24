// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library char_matcher_test;

import 'package:unittest/unittest.dart';
import 'package:more/char_matcher.dart';

void main() {
  group('char matcher', () {
    group('classes', () {

    });
    group('operations', () {
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