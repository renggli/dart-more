import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('binomial', () {
    group('values', () {
      test('int', () {
        check(7.binomial(0)).equals(1);
        check(7.binomial(1)).equals(7);
        check(7.binomial(2)).equals(21);
        check(7.binomial(3)).equals(35);
        check(7.binomial(4)).equals(35);
        check(7.binomial(5)).equals(21);
        check(7.binomial(6)).equals(7);
        check(7.binomial(7)).equals(1);
      });
      test('BigInt', () {
        check(BigInt.from(7).binomial(BigInt.from(0))).equals(BigInt.from(1));
        check(BigInt.from(7).binomial(BigInt.from(1))).equals(BigInt.from(7));
        check(BigInt.from(7).binomial(BigInt.from(2))).equals(BigInt.from(21));
        check(BigInt.from(7).binomial(BigInt.from(3))).equals(BigInt.from(35));
        check(BigInt.from(7).binomial(BigInt.from(4))).equals(BigInt.from(35));
        check(BigInt.from(7).binomial(BigInt.from(5))).equals(BigInt.from(21));
        check(BigInt.from(7).binomial(BigInt.from(6))).equals(BigInt.from(7));
        check(BigInt.from(7).binomial(BigInt.from(7))).equals(BigInt.from(1));
      });
    });
    group('bounds', () {
      test('int', () {
        check(() => 7.binomial(-1)).throws<ArgumentError>();
        check(() => 7.binomial(8)).throws<ArgumentError>();
      });
      test('BigInt', () {
        check(() => BigInt.from(7).binomial(BigInt.from(-1)))
            .throws<ArgumentError>();
        check(() => BigInt.from(7).binomial(BigInt.from(8)))
            .throws<ArgumentError>();
      });
    });
  });
}
