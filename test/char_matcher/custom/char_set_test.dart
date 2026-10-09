import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
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
      verify(CharMatcher.charSet('^a-z[]'), '^a-z[]', 'by');
    });
    test('unicode', () {
      verify(CharMatcher.charSet('↖⇨'), '↖⇨', 'abc←↯');
    });
  });
}
