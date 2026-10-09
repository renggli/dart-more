import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('punctuation', () {
    test('punctuation', () {
      verify(
        const CharMatcher.punctuation(),
        '!"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~',
        'abc123 ',
      );
    });
  });
}
