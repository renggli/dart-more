import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('lcm', () {
    test('int', () {
      check(5.lcm(2)).equals(10);
      check(2.lcm(5)).equals(10);
      check(5.lcm(0)).equals(0);
      check(0.lcm(5)).equals(0);
      check(0.lcm(0)).equals(0);
      check((-4).lcm(6)).equals(12);
      check(4.lcm(-6)).equals(12);
      check((-4).lcm(-6)).equals(12);
    });
    test('Iterable<int>', () {
      check([4].lcm()).equals(4);
      check([2, 5].lcm()).equals(10);
      check([2, 3, 5].lcm()).equals(30);
      check([2, 9, 3, 2].lcm()).equals(18);
      check([-4, 6].lcm()).equals(12);
    });
    test('BigInt', () {
      check(BigInt.from(5).lcm(BigInt.from(2))).equals(BigInt.from(10));
      check(BigInt.from(2).lcm(BigInt.from(5))).equals(BigInt.from(10));
      check(BigInt.from(5).lcm(BigInt.from(0))).equals(BigInt.from(0));
      check(BigInt.from(0).lcm(BigInt.from(5))).equals(BigInt.from(0));
      check(BigInt.zero.lcm(BigInt.zero)).equals(BigInt.zero);
      check(BigInt.from(-4).lcm(BigInt.from(6))).equals(BigInt.from(12));
      check(BigInt.from(4).lcm(BigInt.from(-6))).equals(BigInt.from(12));
      check(BigInt.from(-4).lcm(BigInt.from(-6))).equals(BigInt.from(12));
    });
    test('Iterable<BigInt>', () {
      check([BigInt.from(4)].lcm()).equals(BigInt.from(4));
      check([BigInt.from(2), BigInt.from(5)].lcm()).equals(BigInt.from(10));
      check([BigInt.from(2), BigInt.from(3), BigInt.from(5)].lcm())
          .equals(BigInt.from(30));
      check(
        [BigInt.from(2), BigInt.from(9), BigInt.from(3), BigInt.from(2)].lcm(),
      ).equals(BigInt.from(18));
    });
  });
}
