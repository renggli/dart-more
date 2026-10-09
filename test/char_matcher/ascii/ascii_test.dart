import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('ascii', () {
    test('ascii', () {
      verify(const CharMatcher.ascii(), 'def123_!@#', '\u2665');
    });
  });
}
