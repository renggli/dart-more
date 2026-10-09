import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('letter', () {
    test('letter', () {
      verify(
        const CharMatcher.letter(),
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
        '123_!@# ',
      );
    });
  });
}
