import '../../ordering.dart';

extension OperatorsExtension<E> on Iterable<E> {
  /// Returns the minimum of this [Iterable]. The elements need to be
  /// [Comparable], unless a [key] extractor is provided.
  ///
  /// Throws a [StateError] if the iterable is empty, unless an [orElse]
  /// function is provided.
  ///
  /// For example
  ///
  ///    [3, 1, 2].min()
  ///
  /// returns `1`.
  ///
  E min({Comparable Function(E value)? key, E Function()? orElse}) =>
      _ordering(key).minOf(this, orElse: orElse);

  /// Returns the maximum of this [Iterable]. The elements need to be
  /// [Comparable], unless a [key] extractor is provided.
  ///
  /// Throws a [StateError] if the iterable is empty, unless an [orElse]
  /// function is provided.
  ///
  /// For example
  ///
  ///    [3, 1, 2].max()
  ///
  /// returns `3`.
  ///
  E max({Comparable Function(E value)? key, E Function()? orElse}) =>
      _ordering(key).maxOf(this, orElse: orElse);

  /// Returns the value of this [Iterable] at the given [percentile] between
  /// 0.0 and 1.0. Throws a [RangeError] if [percentile] is outside that range.
  /// To return the the median of this collection provide 0.5.
  ///
  /// This implementation is most efficient on already sorted lists, as
  /// otherwise we have to copy and sort the collection first. You can
  /// avoid this expensive behavior by setting [isOrdered] to `true`, which
  /// returns the element in the middle of the iterable at the 0.5 percentile.
  E percentile(num percentile,
          {Comparable Function(E value)? key,
          bool isOrdered = false,
          E Function()? orElse}) =>
      _ordering(key)
          .percentile(this, percentile, isOrdered: isOrdered, orElse: orElse);

  // Internal helper to create an ordering (with an optional key).
  Ordering<E> _ordering(Comparable Function(E value)? key) =>
      Ordering.natural().onResultOf<E>(key ?? (key) => key as Comparable);
}
