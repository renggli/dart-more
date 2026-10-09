import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('flatten', () {
    test('empty', () {
      check(<Iterable<int>>[[], [], []].flatten()).isEmpty();
    });
    test('single', () {
      check(
        [
          [1],
          [2],
          [3],
        ].flatten(),
      ).deepEquals([1, 2, 3]);
    });
    test('double', () {
      check(
        [
          [1, 2],
          [3, 4],
          [5, 6],
        ].flatten(),
      ).deepEquals([1, 2, 3, 4, 5, 6]);
    });
  });

  group('deepFlatten', () {
    test('empty', () {
      check(<int>[].deepFlatten<int>()).isEmpty();
    });
    test('flat', () {
      check([1, 2, 3, 4, 5, 6].deepFlatten<int>())
          .deepEquals([1, 2, 3, 4, 5, 6]);
    });
    test('nested', () {
      check(
        [
          1,
          2,
          [
            3,
            4,
            [5, 6],
          ],
        ].deepFlatten<int>(),
      ).deepEquals([1, 2, 3, 4, 5, 6]);
    });
    test('error', () {
      check(() => [1, 'hello'].deepFlatten<int>()).throws<ArgumentError>();
      check(() => [1, null].deepFlatten<int>()).throws<ArgumentError>();
    });
  });
}
