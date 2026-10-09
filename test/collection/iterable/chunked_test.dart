import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('chunked', () {
    test('empty', () {
      final iterable = <int>[].chunked(2);
      check(iterable).isEmpty();
    });
    test('even', () {
      final iterable = [1, 2, 3, 4].chunked(2);
      check(iterable).deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });
    test('odd', () {
      final iterable = [1, 2, 3, 4, 5].chunked(2);
      check(iterable).deepEquals([
        [1, 2],
        [3, 4],
        [5],
      ]);
    });
    test('error', () {
      check(() => <int>[].chunked(0)).throws<RangeError>();
    });
    group('with padding', () {
      test('empty', () {
        final iterable = <int>[].chunkedWithPadding(2, 0);
        check(iterable).isEmpty();
      });
      test('even', () {
        final iterable = [1, 2, 3, 4].chunkedWithPadding(2, 0);
        check(iterable).deepEquals([
          [1, 2],
          [3, 4],
        ]);
      });
      test('odd', () {
        final iterable = [1, 2, 3, 4, 5].chunkedWithPadding(2, 0);
        check(iterable).deepEquals([
          [1, 2],
          [3, 4],
          [5, 0],
        ]);
      });
      test('error', () {
        check(() => <int>[].chunkedWithPadding(0, 2)).throws<RangeError>();
      });
    });
  });
}
