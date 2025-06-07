import 'package:more/src/shared/exceptions.dart';
import 'package:more/src/shared/rle.dart';
import 'package:test/test.dart';

void main() {
  group('checkNonZeroPositive', () {
    test('positive value', () {
      expect(checkNonZeroPositive(5), 5);
    });
    test('value of one', () {
      expect(checkNonZeroPositive(1), 1);
    });
    test('zero value throws RangeError', () {
      expect(() => checkNonZeroPositive(0), throwsRangeError);
    });
    test('negative value throws RangeError', () {
      expect(() => checkNonZeroPositive(-5), throwsRangeError);
    });
  });
  group('rle', () {
    group('encodeRle', () {
      test('empty list', () {
        expect(encodeRle([]), [0]);
      });
      test('single element', () {
        expect(encodeRle([5]), [1, 5]);
      });
      test('repeating elements', () {
        expect(encodeRle([5, 5, 5]), [3, -3, 5]);
      });
      test('mixed elements', () {
        expect(encodeRle([5, 5, 5, 2, 2, 8, 8, 8, 8]), [
          9,
          -3,
          5,
          -2,
          2,
          -4,
          8,
        ]);
      });
      test('alternating elements', () {
        expect(encodeRle([1, 2, 1, 2, 1, 2]), [6, 1, 2, 1, 2, 1, 2]);
      });
      test('long repeating sequence', () {
        expect(encodeRle(List.generate(100, (i) => 7)), [100, -100, 7]);
      });
    });
    group('decodeRle', () {
      test('empty list', () {
        expect(decodeRle([0]), isEmpty);
      });
      test('single element', () {
        expect(decodeRle([1, 5]), [5]);
      });
      test('repeating elements', () {
        expect(decodeRle([3, -3, 5]), [5, 5, 5]);
      });
      test('mixed elements', () {
        expect(decodeRle([9, -3, 5, -2, 2, -4, 8]), [
          5,
          5,
          5,
          2,
          2,
          8,
          8,
          8,
          8,
        ]);
      });
      test('alternating elements', () {
        expect(decodeRle([6, 1, 2, 1, 2, 1, 2]), [1, 2, 1, 2, 1, 2]);
      });
      test('long repeating sequence', () {
        expect(decodeRle([100, -100, 7]), List.generate(100, (i) => 7));
      });
    });
  });
}
