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
    test('full range 0..0x10ffff', () {
      check(optimize([const RangeCharMatcher(0, 0x10ffff)]))
          .isA<AnyCharMatcher>();
    });
    test('offset range of 65536 chars is not AnyCharMatcher', () {
      check(optimize([const RangeCharMatcher(100, 100 + 0xffff)]))
          .not((it) => it.isA<AnyCharMatcher>());
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
    test('merge enclosing ranges', () {
      final matcher = optimize([
        const RangeCharMatcher(65, 90),
        const RangeCharMatcher(70, 75),
      ]);
      check(matcher).isA<RangeCharMatcher>();
      final range = matcher as RangeCharMatcher;
      check(range.start).equals(65);
      check(range.stop).equals(90);
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
