import 'package:checks/checks.dart';
import 'package:more/src/shared/exceptions.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('checkNonZeroPositive', () {
    test('positive value', () {
      check(checkNonZeroPositive(5)).equals(5);
    });
    test('value of one', () {
      check(checkNonZeroPositive(1)).equals(1);
    });
    test('zero value throws RangeError', () {
      check(() => checkNonZeroPositive(0)).throws<RangeError>();
    });
    test('negative value throws RangeError', () {
      check(() => checkNonZeroPositive(-5)).throws<RangeError>();
    });
    test('custom name and message', () {
      check(() => checkNonZeroPositive(0, 'customName', 'customMessage'))
          .throws<RangeError>()
        ..has((e) => e.name, 'name').equals('customName')
        ..has((e) => e.message, 'message').equals('customMessage');
    });
  });
}
