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
  group('isWasm', () {
    test('isTrue', () {
      expect(isWasm, isTrue);
    }, testOn: 'wasm');
    test('isFalse', () {
      expect(isWasm, isFalse);
    }, testOn: '!wasm');
  });
  group('hasAssertionsEnabled', () {
    if (hasAssertionsEnabled) {
      test('isTrue', () {
        expect(() {
          assert(false);
        }, throwsA(isA<AssertionError>()));
      });
    } else {
      test('isFalse', () {
        expect(() {
          assert(false);
        }, isNot(throwsA(isA<AssertionError>())));
      });
    }
  });
  test('minSafeInteger', () {
    expect(minSafeInteger, lessThan(-0xfffffffffff));
    expect(minSafeInteger, -BigInt.two.pow(safeIntegerBits - 1).toInt());
  });
  test('maxSafeInteger', () {
    expect(maxSafeInteger, greaterThan(0xfffffffffff));
    expect(
      maxSafeInteger,
      (BigInt.two.pow(safeIntegerBits - 1) - BigInt.one).toInt(),
    );
  });
}
