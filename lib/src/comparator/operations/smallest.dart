import '../modifiers/reversed.dart';
import 'largest.dart';

extension SmallestComparator<T> on Comparator<T> {
  /// Returns a list of the [k] smallest elements from the given iterable
  /// according to this ordering, in order from smallest to largest.
  List<T> smallest(Iterable<T> iterable, int k) =>
      reversed.largest(iterable, k);
}
