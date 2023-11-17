import 'package:more/feature.dart';
import 'package:test/test.dart';

void main() {
  group('isJavaScript', () {
    test('isTrue', () {
      expect(isJavaScript, isTrue);
    }, testOn: 'js');
    test('isFalse', () {
      expect(isJavaScript, isFalse);
    }, testOn: '!js');
  });
  test('minSafeInteger', () {
    expect(minSafeInteger, lessThan(-0xfffffffffff));
    expect(minSafeInteger, -BigInt.two.pow(safeIntegerBits - 1).toInt());
  });
  test('maxSafeInteger', () {
    expect(maxSafeInteger, greaterThan(0xfffffffffff));
    expect(maxSafeInteger,
        (BigInt.two.pow(safeIntegerBits - 1) - BigInt.one).toInt());
  });
}
