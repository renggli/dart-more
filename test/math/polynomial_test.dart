import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('polynomial', () {
    test('base 2', () {
      check(<int>[].polynomial(2)).equals(0);
      check([1, 2].polynomial(2)).equals(5);
      check([1, 2, 3].polynomial(2)).equals(17);
      check([1, 2, 3, 4].polynomial(2)).equals(49);
    });
    test('base 10', () {
      check(<int>[].polynomial()).equals(0);
      check([1, 2].polynomial()).equals(21);
      check([1, 2, 3].polynomial()).equals(321);
      check([1, 2, 3, 4].polynomial()).equals(4321);
    });
  });
}
