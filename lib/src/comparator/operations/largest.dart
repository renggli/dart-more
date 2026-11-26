import 'package:collection/collection.dart';

/// Extension on [Comparator] to find the largest elements.
extension LargestComparator<T> on Comparator<T> {
  /// Returns a fixed-length list of the [k] largest elements of the given
  /// iterable according to this ordering, in order from largest to smallest.
  List<T> largest(Iterable<T> iterable, int k) {
    RangeError.checkNotNegative(k, 'k');
    if (k == 0) return List<T>.empty();
    final heap = PriorityQueue<T>(this);
    for (final each in iterable) {
      if (heap.length < k) {
        heap.add(each);
      } else if (this(each, heap.first) > 0) {
        heap.removeFirst(); // drop the smallest element
        heap.add(each);
      }
    }
    final result = List.generate(
      heap.length,
      (index) => heap.removeFirst(),
      growable: false,
    );
    result.reverseRange(0, result.length);
    return result;
  }
}
