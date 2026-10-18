import 'package:checks/checks.dart';
import 'package:more/feature.dart';
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
        check(18.factorial()).equals(6402373705728000);
        if (!isJavaScript) {
          check(19.factorial()).equals(121645100408832000);
          check(20.factorial()).equals(2432902008176640000);
        }
      });
      test('BigInt', () {
        check(BigInt.from(0).factorial()).equals(BigInt.from(1));
        check(BigInt.from(1).factorial()).equals(BigInt.from(1));
        check(BigInt.from(5).factorial()).equals(BigInt.from(120));
        check(BigInt.from(12).factorial()).equals(BigInt.from(479001600));
        check(BigInt.from(20).factorial())
            .equals(BigInt.parse('2432902008176640000'));
        check(BigInt.from(21).factorial())
            .equals(BigInt.parse('51090942171709440000'));
        check(BigInt.from(22).factorial())
            .equals(BigInt.parse('1124000727777607680000'));
      });
    });
    group('bounds', () {
      test('int', () {
        check(() => (-1).factorial()).throws<ArgumentError>();
        if (isJavaScript) {
          check(() => 19.factorial()).throws<ArgumentError>();
        } else {
          check(() => 21.factorial()).throws<ArgumentError>();
        }
      });
      test('BigInt', () {
        check(() => (-BigInt.one).factorial()).throws<ArgumentError>();
        check(() => (BigInt.from(-1) - (BigInt.one << 65)).factorial())
            .throws<ArgumentError>();
      });
    });
  });
}
