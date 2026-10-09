import 'package:checks/checks.dart';
import 'package:more/number.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('BigInt', () {
    test('static', () {
      check(BigIntExtension.negativeOne).equals(-BigInt.one);
      check(BigIntExtension.negativeTwo).equals(-BigInt.two);
    });
  });
}
