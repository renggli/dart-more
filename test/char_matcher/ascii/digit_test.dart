import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('digit', () {
    test('digit', () {
      verify(const CharMatcher.digit(), '0123456789', 'abc_!@# ');
    });
  });
}
