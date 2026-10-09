import 'package:more/collection.dart';
import 'package:more/src/char_matcher/basic/lookup.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('lookup', () {
    final buffer = BitList(10);
    buffer.setUnchecked(0, true);
    buffer.setUnchecked(3, true);
    buffer.setUnchecked(5, true);
    buffer.setUnchecked(9, true);
    final matcher = LookupCharMatcher(100, 109, buffer);
    test('match', () {
      verify(
        matcher,
        String.fromCharCodes([100, 103, 105, 109]),
        String.fromCharCodes([99, 101, 102, 104, 106, 107, 108, 110]),
      );
    });
  });
}
