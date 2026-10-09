import 'package:more/char_matcher.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('whitespace', () {
    test('whitespace', () {
      verify(const CharMatcher.whitespace(), '\t\n\r\v\f ', 'abcABC_!@#\u0000');
    });
  });
}
