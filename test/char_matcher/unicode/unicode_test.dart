import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('unicode', () {
    test('asserts on invalid data length', () {
      check(() => UnicodeCharMatcher(const [1, 2, 3], 1))
          .throws<AssertionError>();
    });
    test('asserts on invalid mask', () {
      final validData = List.filled(0x10ffff + 1, 0);
      check(() => UnicodeCharMatcher(validData, 0x100000000))
          .throws<AssertionError>();
    });
    test('match with custom data', () {
      final validData = List.filled(0x10ffff + 1, 0);
      validData[65] = 1;
      validData[66] = 2;
      final matcher = UnicodeCharMatcher(validData, 1);
      check(matcher.match(65)).isTrue();
      check(matcher.match(66)).isFalse();
      check(matcher.match(67)).isFalse();
    });
  });
}
