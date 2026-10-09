import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('letterOrDigit', () {
    test('letterOrDigit', () {
      verify(
        const CharMatcher.letterOrDigit(),
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_',
        '!@# ',
      );
    });
  });
}
