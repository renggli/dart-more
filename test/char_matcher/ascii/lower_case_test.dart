import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('lowerCaseLetter', () {
    test('lowerCaseLetter', () {
      verify(
        const CharMatcher.lowerCaseLetter(),
        'abcdefghijklmnopqrstuvwxyz',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ123_!@# ',
      );
    });
  });
}
