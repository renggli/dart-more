// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

/**
 * A collection of extension functions for collections.
 */
library collection;

import 'dart:collection';

/**
 * Searches the specified [list] for the specified [value] using binary search.
 *
 * The [compare] function takes two arguments [a] and [b] and returns
 *
 *  -1 if [:x < y:],
 *   0 if [:x == y:], and
 *   1 if [:x > y:].
 *
 * The method returns the index of the element, or a negative value if the key
 * was not found.
 */
int binarySearch(List list, value, [int compare(a, b)]) {
  return _binarySearch(list, value, 0, list.length - 1, compare);
}

int _binarySearch(List list, value, int low, int high, [int compare(a, b)]) {
  if (compare == null) {
    compare = Comparable.compare;
  }
  while (low <= high) {
    var mid = low + (high - low) ~/ 2;
    var cmp = compare(list[mid], value);
    if (cmp > 0) {
      high = mid - 1;
    } else if (cmp < 0) {
      low = mid + 1;
    } else {
      return mid;
    }
  }
  return -low - 1;
}