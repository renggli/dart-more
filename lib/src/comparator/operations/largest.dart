import 'dart:math' as math;

import 'package:collection/collection.dart';

extension LargestComparator<T> on Comparator<T> {
  /// Returns a list of the [k] largest elements of the given iterable
  /// according to this ordering, in order from largest to smallest.
  List<T> largest(Iterable<T> iterable, int k) {
    final heap = PriorityQueue<T>(this);
    for (final each in iterable) {
      heap.add(each);
      if (heap.length > k) {
        heap.removeFirst(); // drop the largest element
      }
    }
    final result = List.generate(
        math.min(k, heap.length), (index) => heap.removeFirst(),
        growable: false);
    result.reverseRange(0, result.length);
    return result;
  }
}
