// ignore_for_file: deprecated_member_use_from_same_package

import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('keyOf', () {
    test('default', () {
      final comparator = keyOf<String, num>((string) => string.length);
      verify(comparator, ['abc', 'ab'], ['ab', 'abc']);
      verify(comparator, ['ab', 'a'], ['a', 'ab']);
      verify(comparator, ['ab', 'abc', 'a'], ['a', 'ab', 'abc']);
      verify(comparator, ['ab', 'abc', 'a'], ['a', 'ab', 'abc']);
    });

    test('delegateComparator (deprecated)', () {
      final comparator = delegateComparator<String, num>(
        (string) => string.length,
      );
      verify(comparator, ['abc', 'ab'], ['ab', 'abc']);
      verify(comparator, ['ab', 'a'], ['a', 'ab']);
      verify(comparator, ['ab', 'abc', 'a'], ['a', 'ab', 'abc']);
      verify(comparator, ['ab', 'abc', 'a'], ['a', 'ab', 'abc']);
    });
  });
}
