import '../modifiers/reversed.dart';
import 'smallest.dart';

extension LargestComparator<T> on Comparator<T> {
  /// Returns a list of the [k] largest elements of the given iterable
  /// according to this ordering, in order from largest to smallest.
  List<T> largest(Iterable<T> iterable, int k) =>
      reversed.smallest(iterable, k);
}
