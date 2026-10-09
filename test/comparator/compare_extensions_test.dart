import 'package:checks/checks.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('compare extensions', () {
    test('between', () {
      check(1.between(2, 4)).isFalse();
      check(2.between(2, 4)).isTrue();
      check(3.between(2, 4)).isTrue();
      check(4.between(2, 4)).isTrue();
      check(5.between(2, 4)).isFalse();
    });

    test('clip', () {
      check(1.clip(2, 4)).equals(2);
      check(2.clip(2, 4)).equals(2);
      check(3.clip(2, 4)).equals(3);
      check(4.clip(2, 4)).equals(4);
      check(5.clip(2, 4)).equals(4);
    });
  });
}
