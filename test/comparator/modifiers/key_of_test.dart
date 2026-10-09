// ignore_for_file: deprecated_member_use_from_same_package

import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('keyOf modifier', () {
    test('keyOf', () {
      final comparator = naturalInt.keyOf<String>((s) => s.length);
      verify(comparator, ['*', '**', '***'], ['*', '**', '***']);
      verify(comparator, ['**', '***', '*'], ['*', '**', '***']);
      verify(comparator, ['***', '*', '**'], ['*', '**', '***']);
      verify(comparator, ['***', '**', '*'], ['*', '**', '***']);
    });

    test('onResultOf (deprecated)', () {
      final comparator = naturalInt.onResultOf<String>((s) => s.length);
      verify(comparator, ['*', '**', '***'], ['*', '**', '***']);
      verify(comparator, ['**', '***', '*'], ['*', '**', '***']);
      verify(comparator, ['***', '*', '**'], ['*', '**', '***']);
      verify(comparator, ['***', '**', '*'], ['*', '**', '***']);
    });
  });
}
