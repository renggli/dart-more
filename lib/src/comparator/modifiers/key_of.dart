import '../../../functional.dart';

extension ResultOfComparator<R> on Comparator<R> {
  /// Returns a [Comparator] of type [T] that extracts a sort key of type [R].
  Comparator<T> keyOf<T>(Map1<T, R> function) =>
      (a, b) => this(function(a), function(b));

  /// Returns a [Comparator] of type [T] that extracts a sort key of type [R].
  @Deprecated('Use `keyOf` instead.')
  Comparator<T> onResultOf<T>(Map1<T, R> function) => keyOf<T>(function);
}
