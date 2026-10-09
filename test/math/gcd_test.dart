import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('gcd', () {
    test('int', () {
      check(48.gcd(18)).equals(6);
      check(18.gcd(48)).equals(6);
      check(41.gcd(53)).equals(1);
      check(53.gcd(41)).equals(1);
    });
    test('Iterable<int>', () {
      check([48].gcd()).equals(48);
      check([48, 18].gcd()).equals(6);
      check([48, 18, 53].gcd()).equals(1);
    });
    test('BigInt', () {
      check(BigInt.from(48).gcd(BigInt.from(18))).equals(BigInt.from(6));
      check(BigInt.from(18).gcd(BigInt.from(48))).equals(BigInt.from(6));
      check(BigInt.from(41).gcd(BigInt.from(53))).equals(BigInt.from(1));
      check(BigInt.from(53).gcd(BigInt.from(41))).equals(BigInt.from(1));
    });
    test('Iterable<BigInt>', () {
      check([BigInt.from(48)].gcd()).equals(BigInt.from(48));
      check([BigInt.from(48), BigInt.from(18)].gcd()).equals(BigInt.from(6));
      check([BigInt.from(48), BigInt.from(18), BigInt.from(53)].gcd())
          .equals(BigInt.from(1));
    });
  });
}
