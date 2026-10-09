import 'package:checks/checks.dart';
import 'package:more/src/char_matcher/basic/lookup.dart';
import 'package:more/src/char_matcher/basic/range.dart';
import 'package:more/src/char_matcher/basic/ranges.dart';
import 'package:more/src/char_matcher/basic/single.dart';
import 'package:more/src/char_matcher/custom/optimize.dart';
import 'package:more/src/char_matcher/operator/any.dart';
import 'package:more/src/char_matcher/operator/none.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('optimize', () {
    test('empty', () {
      check(optimize([])).isA<NoneCharMatcher>();
    });
    test('full range 0..0xffff', () {
      check(optimize([const RangeCharMatcher(0, 0xffff)]))
          .isA<AnyCharMatcher>();
    });
    test('single character', () {
      check(optimize([const RangeCharMatcher(65, 65)]))
          .isA<SingleCharMatcher>();
    });
    test('single range', () {
      check(optimize([const RangeCharMatcher(65, 90)])).isA<RangeCharMatcher>();
    });
    test('merge adjacent ranges', () {
      final matcher = optimize([
        const RangeCharMatcher(10, 15),
        const RangeCharMatcher(16, 20),
      ]);
      check(matcher).isA<RangeCharMatcher>();
    });
    test('merge overlapping ranges', () {
      final matcher = optimize([
        const RangeCharMatcher(10, 18),
        const RangeCharMatcher(15, 20),
      ]);
      check(matcher).isA<RangeCharMatcher>();
    });
    test('lookup matcher for compact ranges', () {
      final matcher = optimize([
        const RangeCharMatcher(10, 12),
        const RangeCharMatcher(15, 17),
      ]);
      check(matcher).isA<LookupCharMatcher>();
    });
    test('ranges matcher for widely spaced ranges', () {
      final matcher = optimize([
        const RangeCharMatcher(0, 1),
        const RangeCharMatcher(0x20000, 0x20001),
      ]);
      check(matcher).isA<RangesCharMatcher>();
    });
  });
}
