import '../../../functional.dart';

extension ResultOfComparator<R> on Comparator<R> {
  /// Returns a [Comparator] of type [T] that extracts a sort key of type [R].
  Comparator<T> onResultOf<T>(Map1<T, R> function) =>
      (a, b) => this(function(a), function(b));
}
