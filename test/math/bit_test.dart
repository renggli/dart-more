import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('bit', () {
    final powersOf2 = List.generate(32, (i) => math.pow(2, i).toInt());
    group('bitCount', () {
      void checkBitCount(int value, int expectedBitCount) {
        final bitCount = value.bitCount;
        check(
          because:
              'Expected $value (0b${value.toRadixString(2)}) '
              'to have $expectedBitCount bits, but got $bitCount bit.',
          bitCount,
        ).equals(expectedBitCount);
        check(value.hasSingleBit).equals(expectedBitCount == 1);
      }

      test('small', () {
        const bitCount = [
          0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3,
          3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4,
          3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 1, 2,
          2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5,
          3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, //
        ];
        for (var i = 0; i < bitCount.length; i++) {
          checkBitCount(i, bitCount[i]);
        }
      });
      test('single bit set', () {
        for (var i = 1; i <= 0xffffffff; i *= 2) {
          checkBitCount(i, 1);
        }
      });
      test('all bit set', () {
        for (var i = 1; i <= 0xffffffff; i *= 2) {
          checkBitCount(i - 1, i.bitLength - 1);
        }
        checkBitCount(0xffffffff, 32);
      });
      test('random numbers', () {
        final random = math.Random(1121);
        for (var i = 0; i < 1121; i++) {
          final value = random.nextInt(0xffffffff);
          checkBitCount(value, '1'.allMatches(value.toRadixString(2)).length);
        }
      });
    });
    test('hasSingleBit', () {
      for (final value in powersOf2) {
        check(
          because: 'Expected $value to have a single bit.',
          value.hasSingleBit,
        ).isTrue();
        if (value > 2) {
          final smaller = value - 1, bigger = value + 1;
          check(smaller.hasSingleBit).isFalse();
          check(bigger.hasSingleBit).isFalse();
        }
      }
    });
    test('bitFloor', () {
      for (var i = 0; i < powersOf2.length; i++) {
        final previous = i > 0 ? powersOf2[i - 1] : 0;
        final current = powersOf2[i];
        final middle = (previous + current) ~/ 2;
        check(previous.bitFloor).equals(previous);
        if (!middle.hasSingleBit) {
          check(middle.bitFloor).equals(previous);
        }
        check(current.bitFloor).equals(current);
      }
    });
    test('bitCeil', () {
      for (var i = 0; i < powersOf2.length; i++) {
        final previous = i > 0 ? powersOf2[i - 1] : 1;
        final current = powersOf2[i];
        final middle = (previous + current) ~/ 2;
        check(previous.bitCeil).equals(previous);
        if (!middle.hasSingleBit) {
          check(middle.bitCeil).equals(current);
        }
        check(current.bitCeil).equals(current);
      }
    });
    group('setBit', () {
      test('sets the selected bit', () {
        check(0.setBit(0)).equals(0x00000001);
        check(0.setBit(31)).equals(0x80000000);
        check(0xaaaaaaaa.setBit(0)).equals(0xaaaaaaab);
      });
      test('keeps an already set bit', () {
        check(0xffffffff.setBit(13)).equals(0xffffffff);
      });
      test('returns an unsigned 32-bit result', () {
        check((-1).setBit(0)).equals(0xffffffff);
      });
      test('throws on invalid index', () {
        check(() => 0.setBit(-1)).throws<RangeError>();
        check(() => 0.setBit(32)).throws<RangeError>();
      });
    });
    group('clearBit', () {
      test('clears the selected bit', () {
        check(0x00000001.clearBit(0)).equals(0);
        check(0x80000000.clearBit(31)).equals(0);
        check(0xaaaaaaaa.clearBit(1)).equals(0xaaaaaaa8);
      });
      test('keeps an already cleared bit', () {
        check(0.clearBit(13)).equals(0);
      });
      test('returns an unsigned 32-bit result', () {
        check((-1).clearBit(0)).equals(0xfffffffe);
      });
      test('throws on invalid index', () {
        check(() => 0.clearBit(-1)).throws<RangeError>();
        check(() => 0.clearBit(32)).throws<RangeError>();
      });
    });
    group('toggleBit', () {
      test('toggles the selected bit', () {
        check(0.toggleBit(0)).equals(0x00000001);
        check(0.toggleBit(31)).equals(0x80000000);
        check(0xaaaaaaaa.toggleBit(1)).equals(0xaaaaaaa8);
        check(0xaaaaaaaa.toggleBit(0)).equals(0xaaaaaaab);
      });
      test('returns an unsigned 32-bit result', () {
        check((-1).toggleBit(0)).equals(0xfffffffe);
      });
      test('throws on invalid index', () {
        check(() => 0.toggleBit(-1)).throws<RangeError>();
        check(() => 0.toggleBit(32)).throws<RangeError>();
      });
    });
  });
}
