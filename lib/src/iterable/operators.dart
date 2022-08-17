import '../../comparator.dart';

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
  E min({Comparator<E>? comparator, E Function()? orElse}) =>
      (comparator ?? naturalComparator<E>()).minOf(this, orElse: orElse);

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
  E max({Comparator<E>? comparator, E Function()? orElse}) =>
      (comparator ?? naturalComparator<E>()).maxOf(this, orElse: orElse);
}
