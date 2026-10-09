import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('predicates', () {
    test('equalTo', () {
      check(naturalInt.equalTo(1, 1)).isTrue();
      check(naturalInt.equalTo(1, 2)).isFalse();
      check(naturalInt.equalTo(2, 1)).isFalse();
    });

    test('notEqualTo', () {
      check(naturalInt.notEqualTo(1, 1)).isFalse();
      check(naturalInt.notEqualTo(1, 2)).isTrue();
      check(naturalInt.notEqualTo(2, 1)).isTrue();
    });

    test('lessThan', () {
      check(naturalInt.lessThan(1, 1)).isFalse();
      check(naturalInt.lessThan(1, 2)).isTrue();
      check(naturalInt.lessThan(2, 1)).isFalse();
    });

    test('lessThanOrEqualTo', () {
      check(naturalInt.lessThanOrEqualTo(1, 1)).isTrue();
      check(naturalInt.lessThanOrEqualTo(1, 2)).isTrue();
      check(naturalInt.lessThanOrEqualTo(2, 1)).isFalse();
    });

    test('greaterThan', () {
      check(naturalInt.greaterThan(1, 1)).isFalse();
      check(naturalInt.greaterThan(1, 2)).isFalse();
      check(naturalInt.greaterThan(2, 1)).isTrue();
    });

    test('greaterThanOrEqualTo', () {
      check(naturalInt.greaterThanOrEqualTo(1, 1)).isTrue();
      check(naturalInt.greaterThanOrEqualTo(1, 2)).isFalse();
      check(naturalInt.greaterThanOrEqualTo(2, 1)).isTrue();
    });
  });
}
