import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  const Comparator<int> naturalInt = naturalComparable<num>;

  group('min', () {
    test('min', () {
      check(naturalInt.min(1, 1)).equals(1);
      check(naturalInt.min(1, 2)).equals(1);
      check(naturalInt.min(2, 1)).equals(1);
      check(naturalInt.min(2, 2)).equals(2);
    });

    test('minOf', () {
      check(() => naturalInt.minOf([])).throws<StateError>();
      check(naturalInt.minOf([1])).equals(1);
      check(naturalInt.minOf([1, 2])).equals(1);
      check(naturalInt.minOf([2, 1])).equals(1);
      check(naturalInt.minOf([1, 2, 3])).equals(1);
      check(naturalInt.minOf([1, 3, 2])).equals(1);
      check(naturalInt.minOf([2, 1, 3])).equals(1);
      check(naturalInt.minOf([2, 3, 1])).equals(1);
      check(naturalInt.minOf([3, 1, 2])).equals(1);
      check(naturalInt.minOf([3, 2, 1])).equals(1);
    });

    test('minOf orElse', () {
      check(naturalInt.minOf([], orElse: () => -1)).equals(-1);
      check(naturalInt.minOf([1], orElse: () => -1)).equals(1);
      check(naturalInt.minOf([1, 2], orElse: () => -1)).equals(1);
      check(naturalInt.minOf([1, 2, 3], orElse: () => -1)).equals(1);
    });
  });

  group('max', () {
    test('max', () {
      check(naturalInt.max(1, 1)).equals(1);
      check(naturalInt.max(1, 2)).equals(2);
      check(naturalInt.max(2, 1)).equals(2);
      check(naturalInt.max(2, 2)).equals(2);
    });

    test('maxOf', () {
      check(() => naturalInt.maxOf([])).throws<StateError>();
      check(naturalInt.maxOf([1])).equals(1);
      check(naturalInt.maxOf([1, 2])).equals(2);
      check(naturalInt.maxOf([2, 1])).equals(2);
      check(naturalInt.maxOf([1, 2, 3])).equals(3);
      check(naturalInt.maxOf([1, 3, 2])).equals(3);
      check(naturalInt.maxOf([2, 1, 3])).equals(3);
      check(naturalInt.maxOf([2, 3, 1])).equals(3);
      check(naturalInt.maxOf([3, 1, 2])).equals(3);
      check(naturalInt.maxOf([3, 2, 1])).equals(3);
    });

    test('maxOf orElse', () {
      check(naturalInt.maxOf([], orElse: () => -1)).equals(-1);
      check(naturalInt.maxOf([1], orElse: () => -1)).equals(1);
      check(naturalInt.maxOf([1, 2], orElse: () => -1)).equals(2);
      check(naturalInt.maxOf([1, 2, 3], orElse: () => -1)).equals(3);
    });
  });

  group('minMaxOf', () {
    test('default', () {
      check(() => naturalInt.minMaxOf([])).throws<StateError>();
      check(naturalInt.minMaxOf([1])).equals((min: 1, max: 1));
      check(naturalInt.minMaxOf([1, 2])).equals((min: 1, max: 2));
      check(naturalInt.minMaxOf([2, 1])).equals((min: 1, max: 2));
      check(naturalInt.minMaxOf([1, 2, 3])).equals((min: 1, max: 3));
      check(naturalInt.minMaxOf([1, 3, 2])).equals((min: 1, max: 3));
      check(naturalInt.minMaxOf([2, 1, 3])).equals((min: 1, max: 3));
      check(naturalInt.minMaxOf([2, 3, 1])).equals((min: 1, max: 3));
      check(naturalInt.minMaxOf([3, 1, 2])).equals((min: 1, max: 3));
      check(naturalInt.minMaxOf([3, 2, 1])).equals((min: 1, max: 3));
    });

    test('orElse', () {
      const sentinel = (min: -1, max: -1);
      check(naturalInt.minMaxOf([], orElse: () => sentinel)).equals(sentinel);
      check(naturalInt.minMaxOf([1], orElse: () => sentinel))
          .equals((min: 1, max: 1));
      check(naturalInt.minMaxOf([1, 2], orElse: () => sentinel))
          .equals((min: 1, max: 2));
      check(naturalInt.minMaxOf([1, 2, 3], orElse: () => sentinel))
          .equals((min: 1, max: 3));
    });
  });
}
