import '../../../functional.dart';

extension ResultOfComparator<T> on Comparator<T> {
  /// Returns a [Comparator] that extracts a sort key of type [R].
  Comparator<R> onResultOf<R>(Map1<R, T> function) =>
      (a, b) => this(function(a), function(b));
}
