import 'dart:math' as math;

import 'package:collection/collection.dart';

import '../../collection/heap.dart';

extension SmallestComparator<T> on Comparator<T> {
  /// Returns a list of the [k] smallest elements from the given iterable
  /// according to this ordering, in order from smallest to largest.
  List<T> smallest(Iterable<T> iterable, int k) {
    final heap = Heap<T>(comparator: this);
    for (final each in iterable) {
      heap.push(each);
      if (heap.length > k) {
        heap.pop(); // drop the largest element
      }
    }
    final result = List.generate(
        math.min(k, heap.length), (index) => heap.pop(),
        growable: false);
    result.reverseRange(0, result.length);
    return result;
  }
}
