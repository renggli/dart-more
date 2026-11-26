import 'package:checks/checks.dart';
import 'package:more/src/shared/bit.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('countBits32', () {
    test('zero and single bits', () {
      check(countBits32(0)).equals(0);
      for (var i = 0; i < 32; i++) {
        check(countBits32(1 << i)).equals(1);
      }
    });

    test('all ones and alternating patterns', () {
      check(countBits32(0xffffffff)).equals(32);
      check(countBits32(0xaaaaaaaa)).equals(16);
      check(countBits32(0x55555555)).equals(16);
    });

    test('masks values above 32 bits and negative ints', () {
      check(countBits32(-1)).equals(32);
      check(countBits32(0x1ffffffff)).equals(32);
      check(countBits32(0x100000000)).equals(0);
    });
  });
}
