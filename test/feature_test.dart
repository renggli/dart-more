import 'package:checks/checks.dart';
import 'package:more/feature.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('isJavaScript', () {
    test('isTrue', () {
      check(isJavaScript).isTrue();
    }, testOn: 'js');
    test('isFalse', () {
      check(isJavaScript).isFalse();
    }, testOn: '!js');
  });
  group('isWasm', () {
    test('isTrue', () {
      check(isWasm).isTrue();
    }, testOn: 'wasm');
    test('isFalse', () {
      check(isWasm).isFalse();
    }, testOn: '!wasm');
  });
  group('hasAssertionsEnabled', () {
    if (hasAssertionsEnabled) {
      test('isTrue', () {
        check(() {
          assert(false);
        }).throws<AssertionError>();
      });
    } else {
      test('isFalse', () {
        check(() {
          assert(false);
        }).returnsNormally();
      });
    }
  });
  test('minSafeInteger', () {
    check(minSafeInteger).isLessThan(-0xfffffffffff);
    check(minSafeInteger).equals(-BigInt.two.pow(safeIntegerBits - 1).toInt());
  });
  test('maxSafeInteger', () {
    check(maxSafeInteger).isGreaterThan(0xfffffffffff);
    check(maxSafeInteger)
        .equals((BigInt.two.pow(safeIntegerBits - 1) - BigInt.one).toInt());
  });
}
