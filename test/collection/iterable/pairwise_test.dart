import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('pairwise', () {
    test('empty', () {
      final iterator = <int>[].pairwise();
      check(iterator).isEmpty();
    });
    test('1 element', () {
      final iterator = <int>[1].pairwise();
      check(iterator).isEmpty();
    });
    test('2 elements', () {
      final iterator = <int>[1, 2].pairwise();
      check(iterator).deepEquals([(1, 2)]);
    });
    test('3 elements', () {
      final iterator = <int>[1, 2, 3].pairwise();
      check(iterator).deepEquals([(1, 2), (2, 3)]);
    });
    test('4 elements', () {
      final iterator = <int>[1, 2, 3, 4].pairwise();
      check(iterator).deepEquals([(1, 2), (2, 3), (3, 4)]);
    });
  });
}
