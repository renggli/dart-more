import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:more/src/char_matcher/char_match.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('char_match', () {
    test('direct instantiation', () {
      const matcher = CharMatcher.digit();
      const match = CharMatch(1, 3, 'hello', matcher);
      check(match.start).equals(1);
      check(match.end).equals(3);
      check(match.input).equals('hello');
      check(match.pattern).equals(matcher);
      check(match.groupCount).equals(0);
      check(match.group(0)).equals('el');
      check(() => match.group(-1)).throws<RangeError>();
      check(() => match.group(1)).throws<RangeError>();
      check(match[0]).equals('el');
      check(() => match[1]).throws<RangeError>();
      check(match.groups([0])).deepEquals(['el']);
      check(() => match.groups([0, 1])).throws<RangeError>();
    });
    test('allMatches()', () {
      const input = 'a1b2c';
      const pattern = CharMatcher.digit();
      final matches = pattern.allMatches(input).toList();
      check(matches.map((matcher) => matcher.pattern))
          .deepEquals([pattern, pattern]);
      check(matches.map((matcher) => matcher.input)).deepEquals([input, input]);
      check(matches.map((matcher) => matcher.start)).deepEquals([1, 3]);
      check(matches.map((matcher) => matcher.end)).deepEquals([2, 4]);
      check(matches.map((matcher) => matcher.groupCount)).deepEquals([0, 0]);
      check(matches.map((matcher) => matcher[0])).deepEquals(['1', '2']);
      check(matches.map((matcher) => matcher.group(0))).deepEquals(['1', '2']);
      check(matches.map((matcher) => matcher.groups([0]))).deepEquals([
        ['1'],
        ['2'],
      ]);
      check(() => matches.first.group(1)).throws<RangeError>();
    });
    test('matchAsPrefix()', () {
      const input = 'a1b2c';
      const pattern = CharMatcher.digit();
      final match1 = pattern.matchAsPrefix(input);
      check(match1).isNull;
      final match2 = pattern.matchAsPrefix(input, 1);
      check(match2).isNotNull()
        ..has('pattern', (m) => m.pattern).equals(pattern)
        ..has('input', (m) => m.input).equals(input)
        ..has('start', (m) => m.start).equals(1)
        ..has('end', (m) => m.end).equals(2)
        ..has('groupCount', (m) => m.groupCount).equals(0)
        ..has('operator[]', (m) => m[0]).equals('1')
        ..has('group(0)', (m) => m.group(0)).equals('1')
        ..has('groups([0])', (m) => m.groups([0])).deepEquals(['1']);
      check(() => match2![1]).throws<RangeError>();
    });
  });
}
