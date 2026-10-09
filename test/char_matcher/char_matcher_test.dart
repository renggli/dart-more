import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('char_matcher', () {
    final star = CharMatcher.isChar('*');
    test('call()', () {
      check(star('*'.codeUnitAt(0))).isTrue();
      check(star('a'.codeUnitAt(0))).isFalse();
    });
    group('action', () {
      test('anyOf', () {
        check(star.anyOf('')).isFalse();
        check(star.anyOf('a')).isFalse();
        check(star.anyOf('*')).isTrue();
        check(star.anyOf('ab')).isFalse();
        check(star.anyOf('a*')).isTrue();
        check(star.anyOf('*b')).isTrue();
        check(star.anyOf('**')).isTrue();
      });
      test('everyOf', () {
        check(star.everyOf('')).isTrue();
        check(star.everyOf('a')).isFalse();
        check(star.everyOf('*')).isTrue();
        check(star.everyOf('ab')).isFalse();
        check(star.everyOf('a*')).isFalse();
        check(star.everyOf('*b')).isFalse();
        check(star.everyOf('**')).isTrue();
      });
      test('noneOf', () {
        check(star.noneOf('')).isTrue();
        check(star.noneOf('a')).isTrue();
        check(star.noneOf('*')).isFalse();
        check(star.noneOf('ab')).isTrue();
        check(star.noneOf('a*')).isFalse();
        check(star.noneOf('*b')).isFalse();
        check(star.noneOf('**')).isFalse();
      });
      test('firstIndexIn', () {
        check(star.firstIndexIn('')).equals(-1);
        check(star.firstIndexIn('*')).equals(0);
        check(star.firstIndexIn('**')).equals(0);
        check(star.firstIndexIn('a')).equals(-1);
        check(star.firstIndexIn('a*')).equals(1);
        check(star.firstIndexIn('a**')).equals(1);
        check(star.firstIndexIn('*', 1)).equals(-1);
        check(star.firstIndexIn('**', 1)).equals(1);
        check(star.firstIndexIn('\u{10000}*', 1)).equals(2);
      });
      test('lastIndexIn', () {
        check(star.lastIndexIn('')).equals(-1);
        check(star.lastIndexIn('*')).equals(0);
        check(star.lastIndexIn('**')).equals(1);
        check(star.lastIndexIn('a')).equals(-1);
        check(star.lastIndexIn('*a')).equals(0);
        check(star.lastIndexIn('**a')).equals(1);
        check(star.lastIndexIn('*', 0)).equals(0);
        check(star.lastIndexIn('**', 0)).equals(0);
        check(star.lastIndexIn('*\u{10000}', 2)).equals(0);
      });
      test('countIn', () {
        check(star.countIn('')).equals(0);
        check(star.countIn('*')).equals(1);
        check(star.countIn('**')).equals(2);
        check(star.countIn('a')).equals(0);
        check(star.countIn('ab')).equals(0);
        check(star.countIn('a*b')).equals(1);
        check(star.countIn('*a*b')).equals(2);
        check(star.countIn('*a*b*')).equals(3);
      });
      test('collapseFrom', () {
        check(star.collapseFrom('', '')).equals('');
        check(star.collapseFrom('', '!')).equals('');
        check(star.collapseFrom('', '!!')).equals('');
        check(star.collapseFrom('*', '')).equals('');
        check(star.collapseFrom('*', '!')).equals('!');
        check(star.collapseFrom('*', '!!')).equals('!!');
        check(star.collapseFrom('**', '')).equals('');
        check(star.collapseFrom('**', '!')).equals('!');
        check(star.collapseFrom('**', '!!')).equals('!!');
        check(star.collapseFrom('*a*', '')).equals('a');
        check(star.collapseFrom('*a*', '!')).equals('!a!');
        check(star.collapseFrom('*a*', '!!')).equals('!!a!!');
        check(star.collapseFrom('**a**', '')).equals('a');
        check(star.collapseFrom('**a**', '!')).equals('!a!');
        check(star.collapseFrom('**a**', '!!')).equals('!!a!!');
        check(star.collapseFrom('a*b*c', '')).equals('abc');
        check(star.collapseFrom('a*b*c', '!')).equals('a!b!c');
        check(star.collapseFrom('a*b*c', '!!')).equals('a!!b!!c');
        check(star.collapseFrom('a**b**c', '')).equals('abc');
        check(star.collapseFrom('a**b**c', '!')).equals('a!b!c');
        check(star.collapseFrom('a**b**c', '!!')).equals('a!!b!!c');
      });
      test('replaceFrom', () {
        check(star.replaceFrom('', '')).equals('');
        check(star.replaceFrom('', '!')).equals('');
        check(star.replaceFrom('', '!!')).equals('');
        check(star.replaceFrom('*', '')).equals('');
        check(star.replaceFrom('*', '!')).equals('!');
        check(star.replaceFrom('*', '!!')).equals('!!');
        check(star.replaceFrom('**', '')).equals('');
        check(star.replaceFrom('**', '!')).equals('!!');
        check(star.replaceFrom('**', '!!')).equals('!!!!');
        check(star.replaceFrom('*a*', '')).equals('a');
        check(star.replaceFrom('*a*', '!')).equals('!a!');
        check(star.replaceFrom('*a*', '!!')).equals('!!a!!');
        check(star.replaceFrom('**a**', '')).equals('a');
        check(star.replaceFrom('**a**', '!')).equals('!!a!!');
        check(star.replaceFrom('**a**', '!!')).equals('!!!!a!!!!');
        check(star.replaceFrom('a*b*c', '')).equals('abc');
        check(star.replaceFrom('a*b*c', '!')).equals('a!b!c');
        check(star.replaceFrom('a*b*c', '!!')).equals('a!!b!!c');
        check(star.replaceFrom('a**b**c', '')).equals('abc');
        check(star.replaceFrom('a**b**c', '!')).equals('a!!b!!c');
        check(star.replaceFrom('a**b**c', '!!')).equals('a!!!!b!!!!c');
      });
      test('removeFrom', () {
        check(star.removeFrom('')).equals('');
        check(star.removeFrom('*')).equals('');
        check(star.removeFrom('**')).equals('');
        check(star.removeFrom('*a')).equals('a');
        check(star.removeFrom('*a*')).equals('a');
        check(star.removeFrom('*a*b')).equals('ab');
        check(star.removeFrom('*a*b*')).equals('ab');
        check(star.removeFrom('a*b*')).equals('ab');
        check(star.removeFrom('ab*')).equals('ab');
        check(star.removeFrom('ab')).equals('ab');
      });
      test('retainFrom', () {
        check(star.retainFrom('')).equals('');
        check(star.retainFrom('*')).equals('*');
        check(star.retainFrom('**')).equals('**');
        check(star.retainFrom('*a')).equals('*');
        check(star.retainFrom('*a*')).equals('**');
        check(star.retainFrom('*a*b')).equals('**');
        check(star.retainFrom('*a*b*')).equals('***');
        check(star.retainFrom('a*b*')).equals('**');
        check(star.retainFrom('ab*')).equals('*');
        check(star.retainFrom('ab')).equals('');
      });
      test('trimFrom', () {
        check(star.trimFrom('')).equals('');
        check(star.trimFrom('*')).equals('');
        check(star.trimFrom('**')).equals('');
        check(star.trimFrom('*a')).equals('a');
        check(star.trimFrom('**a')).equals('a');
        check(star.trimFrom('*ab')).equals('ab');
        check(star.trimFrom('a*')).equals('a');
        check(star.trimFrom('a**')).equals('a');
        check(star.trimFrom('ab*')).equals('ab');
        check(star.trimFrom('*a*')).equals('a');
        check(star.trimFrom('**a**')).equals('a');
        check(star.trimFrom('*ab*')).equals('ab');
      });
      test('trimLeadingFrom', () {
        check(star.trimLeadingFrom('')).equals('');
        check(star.trimLeadingFrom('*')).equals('');
        check(star.trimLeadingFrom('**')).equals('');
        check(star.trimLeadingFrom('*a')).equals('a');
        check(star.trimLeadingFrom('**a')).equals('a');
        check(star.trimLeadingFrom('*ab')).equals('ab');
        check(star.trimLeadingFrom('a*')).equals('a*');
        check(star.trimLeadingFrom('a**')).equals('a**');
        check(star.trimLeadingFrom('ab*')).equals('ab*');
        check(star.trimLeadingFrom('*a*')).equals('a*');
        check(star.trimLeadingFrom('**a**')).equals('a**');
        check(star.trimLeadingFrom('*ab*')).equals('ab*');
      });
      test('trimTailingFrom', () {
        check(star.trimTailingFrom('')).equals('');
        check(star.trimTailingFrom('*')).equals('');
        check(star.trimTailingFrom('**')).equals('');
        check(star.trimTailingFrom('*a')).equals('*a');
        check(star.trimTailingFrom('**a')).equals('**a');
        check(star.trimTailingFrom('*ab')).equals('*ab');
        check(star.trimTailingFrom('a*')).equals('a');
        check(star.trimTailingFrom('a**')).equals('a');
        check(star.trimTailingFrom('ab*')).equals('ab');
        check(star.trimTailingFrom('*a*')).equals('*a');
        check(star.trimTailingFrom('**a**')).equals('**a');
        check(star.trimTailingFrom('*ab*')).equals('*ab');
        check(star.trimTailingFrom('\u{1f600}*')).equals('\u{1f600}');
        check(star.trimTailingFrom('*\u{1f600}*')).equals('*\u{1f600}');
      });
    });
    group('pattern', () {
      const input = 'a1b2c';
      const pattern = CharMatcher.digit();
      test('startsWith()', () {
        check(input.startsWith(pattern)).isFalse();
        check(input.startsWith(pattern, 1)).isTrue();
        check(input.startsWith(pattern, 2)).isFalse();
        check(input.startsWith(pattern, 3)).isTrue();
        check(input.startsWith(pattern, 4)).isFalse();
      });
      test('indexOf()', () {
        check(input.indexOf(pattern)).equals(1);
        check(input.indexOf(pattern, 1)).equals(1);
        check(input.indexOf(pattern, 2)).equals(3);
        check(input.indexOf(pattern, 3)).equals(3);
        check(input.indexOf(pattern, 4)).equals(-1);
      });
      test('lastIndexOf()', () {
        check(input.lastIndexOf(pattern)).equals(3);
        check(input.lastIndexOf(pattern, 0)).equals(-1);
        check(input.lastIndexOf(pattern, 1)).equals(1);
        check(input.lastIndexOf(pattern, 2)).equals(1);
        check(input.lastIndexOf(pattern, 3)).equals(3);
        check(input.lastIndexOf(pattern, 4)).equals(3);
      });
      test('contains()', () {
        check(input.contains(pattern)).isTrue();
      });
      test('replaceFirst()', () {
        check(input.replaceFirst(pattern, '!')).equals('a!b2c');
        check(input.replaceFirst(pattern, '!', 1)).equals('a!b2c');
        check(input.replaceFirst(pattern, '!', 2)).equals('a1b!c');
        check(input.replaceFirst(pattern, '!', 3)).equals('a1b!c');
        check(input.replaceFirst(pattern, '!', 4)).equals('a1b2c');
      });
      test('replaceFirstMapped()', () {
        check(input.replaceFirstMapped(pattern, (match) => '!${match[0]}!'))
            .equals('a!1!b2c');
      });
      test('replaceAll()', () {
        check(input.replaceAll(pattern, '!')).equals('a!b!c');
      });
      test('replaceAllMapped()', () {
        check(input.replaceAllMapped(pattern, (match) => '!${match[0]}!'))
            .equals('a!1!b!2!c');
      });
      test('split()', () {
        check(input.split(pattern)).deepEquals(['a', 'b', 'c']);
      });
      test('splitMapJoin()', () {
        check(
          input.splitMapJoin(
            pattern,
            onMatch: (match) => '!${match[0]}!',
            onNonMatch: (nonMatch) => '?$nonMatch?',
          ),
        ).equals('?a?!1!?b?!2!?c?');
      });
      test('astral plane', () {
        check('\u{10000}'.startsWith(pattern)).isFalse();
        check('\u{10000}'.indexOf(pattern)).equals(-1);
        check('\u{10000}'.lastIndexOf(pattern)).equals(-1);
        check('\u{10000}'.contains(pattern)).isFalse();
        check('\u{10000}'.replaceFirst(pattern, '!')).equals('\u{10000}');
        check(
          '\u{10000}'.replaceFirstMapped(pattern, (match) => '!${match[0]}!'),
        ).equals('\u{10000}');
        check('\u{10000}'.replaceAll(pattern, '!')).equals('\u{10000}');
        check('\u{10000}'.replaceAllMapped(pattern, (match) => '!${match[0]}!'))
            .equals('\u{10000}');
        check('\u{10000}'.split(pattern)).deepEquals(['\u{10000}']);
        check('\u{10000}'.splitMapJoin(pattern)).equals('\u{10000}');
      });
    });
  });
}
