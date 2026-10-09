import 'package:checks/checks.dart';
import 'package:more/src/shared/rle.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('rle', () {
    group('encodeRle', () {
      test('empty list', () {
        check(encodeRle([])).deepEquals([0]);
      });
      test('single element', () {
        check(encodeRle([5])).deepEquals([1, 5]);
      });
      test('repeating elements', () {
        check(encodeRle([5, 5, 5])).deepEquals([3, -3, 5]);
      });
      test('mixed elements', () {
        check(encodeRle([5, 5, 5, 2, 2, 8, 8, 8, 8]))
            .deepEquals([9, -3, 5, -2, 2, -4, 8]);
      });
      test('alternating elements', () {
        check(encodeRle([1, 2, 1, 2, 1, 2])).deepEquals([6, 1, 2, 1, 2, 1, 2]);
      });
      test('long repeating sequence', () {
        check(encodeRle(List.generate(100, (i) => 7)))
            .deepEquals([100, -100, 7]);
      });
    });
    group('decodeRle', () {
      test('empty list', () {
        check(decodeRle([0])).isEmpty();
      });
      test('single element', () {
        check(decodeRle([1, 5])).deepEquals([5]);
      });
      test('repeating elements', () {
        check(decodeRle([3, -3, 5])).deepEquals([5, 5, 5]);
      });
      test('mixed elements', () {
        check(decodeRle([9, -3, 5, -2, 2, -4, 8]))
            .deepEquals([5, 5, 5, 2, 2, 8, 8, 8, 8]);
      });
      test('alternating elements', () {
        check(decodeRle([6, 1, 2, 1, 2, 1, 2])).deepEquals([1, 2, 1, 2, 1, 2]);
      });
      test('long repeating sequence', () {
        check(decodeRle([100, -100, 7]))
            .deepEquals(List.generate(100, (i) => 7));
      });
    });
  });
}
