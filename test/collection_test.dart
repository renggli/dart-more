// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library collection_test;

import 'package:unittest/unittest.dart';
import 'package:more/collection.dart';

void main() {
  group('binary search', () {
    test('empty list', () {
      expect(binarySearch([], 5), -1);
    });
    test('simple list', () {
      expect(binarySearch([5], 5), 0);
      expect(binarySearch([1, 5, 6], 5), 1);
      expect(binarySearch([1, 2, 5, 6, 7], 5), 2);
      expect(binarySearch([1, 2, 3, 5, 6, 7, 8], 5), 3);
      expect(binarySearch([1, 2, 3, 4, 5, 6, 7, 8, 9], 5), 4);
    });
    test('right most element', () {
      expect(binarySearch([5], 5), 0);
      expect(binarySearch([1, 5], 5), 1);
      expect(binarySearch([1, 2, 5], 5), 2);
      expect(binarySearch([1, 2, 3, 5], 5), 3);
      expect(binarySearch([1, 2, 3, 4, 5], 5), 4);
    });
    test('left most element', () {
      expect(binarySearch([5], 5), 0);
      expect(binarySearch([5, 6], 5), 0);
      expect(binarySearch([5, 6, 7], 5), 0);
      expect(binarySearch([5, 6, 7, 8], 5), 0);
      expect(binarySearch([5, 6, 7, 8, 9], 5), 0);
    });
  });
}