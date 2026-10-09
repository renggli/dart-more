import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('factorial', () {
    group('values', () {
      test('int', () {
        check(0.factorial()).equals(1);
        check(1.factorial()).equals(1);
        check(5.factorial()).equals(120);
        check(12.factorial()).equals(479001600);
        check(20.factorial()).equals(2432902008176640000);
        check(21.factorial()).equals(2432902008176640000 * 21);
        check(22.factorial()).equals(2432902008176640000 * 21 * 22);
      });
      test('BigInt', () {
        check(BigInt.from(0).factorial()).equals(BigInt.from(1));
        check(BigInt.from(1).factorial()).equals(BigInt.from(1));
        check(BigInt.from(5).factorial()).equals(BigInt.from(120));
        check(BigInt.from(12).factorial()).equals(BigInt.from(479001600));
        check(BigInt.from(20).factorial())
            .equals(BigInt.from(2432902008176640000));
        check(BigInt.from(21).factorial())
            .equals(BigInt.from(2432902008176640000) * BigInt.from(21));
        check(BigInt.from(22).factorial())
            .equals(BigInt.from(2432902008176640000) * BigInt.from(21 * 22));
      });
    });
    group('bounds', () {
      test('int', () {
        check(() => (-1).factorial()).throws<ArgumentError>();
      });
      test('BigInt', () {
        check(() => (-BigInt.one).factorial()).throws<ArgumentError>();
        check(() => (BigInt.from(-1) - (BigInt.one << 65)).factorial())
            .throws<ArgumentError>();
      });
    });
  });
}
