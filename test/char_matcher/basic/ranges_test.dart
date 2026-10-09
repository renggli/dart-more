import 'package:checks/checks.dart';
import 'package:more/src/char_matcher/basic/ranges.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('ranges', () {
    final matcher = RangesCharMatcher(
      3,
      const [10, 30, 50],
      const [20, 40, 60],
    );
    test('match', () {
      verify(
        matcher,
        String.fromCharCodes([10, 15, 20, 30, 35, 40, 50, 55, 60]),
        String.fromCharCodes([0, 9, 21, 25, 29, 41, 45, 49, 61, 100]),
      );
    });
    test('asserts', () {
      check(() => RangesCharMatcher(2, const [1], const [1, 2]))
          .throws<AssertionError>();
      check(() => RangesCharMatcher(2, const [1, 2], const [1]))
          .throws<AssertionError>();
    });
  });
}
