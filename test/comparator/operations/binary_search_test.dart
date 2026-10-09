import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void _binarySearchTests<T>(
  String name, {
  required List<List<T>> examples,
  required List<T> values,
  required List<int> binarySearch,
  required List<int> binarySearchLower,
  required List<int> binarySearchUpper,
}) {
  group(name, () {
    test('binarySearch', () {
      final results = IntegerRange(examples.length)
          .map((i) => naturalCompare.binarySearch(examples[i], values[i]))
          .toList();
      check(results).deepEquals(binarySearch);
    });
    test('binarySearchLower', () {
      final results = IntegerRange(examples.length)
          .map((i) => naturalCompare.binarySearchLower(examples[i], values[i]))
          .toList();
      check(results).deepEquals(binarySearchLower);
    });
    test('binarySearchUpper', () {
      final results = IntegerRange(examples.length)
          .map((i) => naturalCompare.binarySearchUpper(examples[i], values[i]))
          .toList();
      check(results).deepEquals(binarySearchUpper);
    });
  });
}

void main() {
  group('binarySearch', () {
    _binarySearchTests(
      'empty',
      examples: [[], [], []],
      values: [-5, 0, 5],
      binarySearch: [-1, -1, -1],
      binarySearchLower: [0, 0, 0],
      binarySearchUpper: [0, 0, 0],
    );
    _binarySearchTests(
      'simple present',
      examples: [
        [5],
        [1, 5, 6],
        [1, 2, 5, 6, 7],
        [1, 2, 3, 5, 6, 7, 8],
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5, 5],
      binarySearch: [0, 1, 2, 3, 4],
      binarySearchLower: [0, 1, 2, 3, 4],
      binarySearchUpper: [1, 2, 3, 4, 5],
    );
    _binarySearchTests(
      'simple absent',
      examples: [
        [1, 6],
        [1, 2, 6, 7],
        [1, 2, 3, 6, 7, 8],
        [1, 2, 3, 4, 6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5],
      binarySearch: [-1, -1, -1, -1],
      binarySearchLower: [1, 2, 3, 4],
      binarySearchUpper: [1, 2, 3, 4],
    );
    _binarySearchTests(
      'right most present',
      examples: [
        [5],
        [1, 5],
        [1, 2, 5],
        [1, 2, 3, 5],
        [1, 2, 3, 4, 5],
      ],
      values: [5, 5, 5, 5, 5],
      binarySearch: [0, 1, 2, 3, 4],
      binarySearchLower: [0, 1, 2, 3, 4],
      binarySearchUpper: [1, 2, 3, 4, 5],
    );
    _binarySearchTests(
      'right most absent',
      examples: [
        [1],
        [1, 2],
        [1, 2, 3],
        [1, 2, 3, 4],
      ],
      values: [5, 5, 5, 5],
      binarySearch: [-1, -1, -1, -1],
      binarySearchLower: [1, 2, 3, 4],
      binarySearchUpper: [1, 2, 3, 4],
    );
    _binarySearchTests(
      'left most present',
      examples: [
        [5],
        [5, 6],
        [5, 6, 7],
        [5, 6, 7, 8],
        [5, 6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5, 5],
      binarySearch: [0, 0, 0, 0, 0],
      binarySearchLower: [0, 0, 0, 0, 0],
      binarySearchUpper: [1, 1, 1, 1, 1],
    );
    _binarySearchTests(
      'left most absent',
      examples: [
        [6],
        [6, 7],
        [6, 7, 8],
        [6, 7, 8, 9],
      ],
      values: [5, 5, 5, 5],
      binarySearch: [-1, -1, -1, -1],
      binarySearchLower: [0, 0, 0, 0],
      binarySearchUpper: [0, 0, 0, 0],
    );
    _binarySearchTests(
      'binarySearch repeated',
      examples: [
        [1, 5, 9],
        [1, 5, 5, 9],
        [1, 5, 5, 5, 9],
        [1, 5, 5, 5, 5, 9],
        [1, 5, 5, 5, 5, 5, 9],
      ],
      values: [5, 5, 5, 5, 5],
      binarySearch: [1, 2, 2, 3, 3],
      binarySearchLower: [1, 1, 1, 1, 1],
      binarySearchUpper: [2, 3, 4, 5, 6],
    );

    test('binarySearch with range', () {
      final list = [1, 3, 5, 7, 9];
      check(naturalCompare.binarySearch(list, 5, start: 1, end: 4)).equals(2);
      check(naturalCompare.binarySearch(list, 1, start: 1, end: 4)).equals(-1);
      check(naturalCompare.binarySearch(list, 9, start: 1, end: 4)).equals(-1);
    });
  });
}
