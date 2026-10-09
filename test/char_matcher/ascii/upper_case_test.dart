import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('upperCaseLetter', () {
    test('upperCaseLetter', () {
      verify(
        const CharMatcher.upperCaseLetter(),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz123_!@# ',
      );
    });
  });
}
