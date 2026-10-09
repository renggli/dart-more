import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('random', () {
    test('empty', () {
      check(() => <int>[].atRandom()).throws<StateError>();
      check(<int>[].atRandom(orElse: () => -1)).equals(-1);
    });
    test('single', () {
      check([1].atRandom()).equals(1);
      check([2].atRandom()).equals(2);
      check([3].atRandom()).equals(3);
    });
    test('larger', () {
      final seen = <int>{};
      final picks = 0.to(10);
      while (seen.length < picks.length) {
        seen.add(picks.atRandom());
      }
    });
    test('custom', () {
      final seen = <int>{};
      final picks = 0.to(10);
      final random = Random(123456);
      while (seen.length < picks.length) {
        seen.add(picks.atRandom(random: random));
      }
    });
  });
}
