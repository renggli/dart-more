import '../../../comparator.dart';

extension OperatorsIterableExtension<E> on Iterable<E> {
  /// Returns the minimum of this [Iterable]. The elements need to be
  /// [Comparable], unless a custom [comparator] is provided.
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
      (comparator ?? naturalCompare).minOf(this, orElse: orElse);

  /// Returns a list of the [count] smallest elements of this [Iterable]. The
  /// elements need to be [Comparable], unless a custom [comparator] is
  /// provided.
  ///
  /// For example
  ///
  ///    [3, 1, 2].smallest(2)
  ///
  /// returns `[1, 2]`.
  ///
  List<E> smallest(int count, {Comparator<E>? comparator}) =>
      (comparator ?? naturalCompare).smallest(this, count);

  /// Returns the maximum of this [Iterable]. The elements need to be
  /// [Comparable], unless a custom [comparator] is provided.
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
      (comparator ?? naturalCompare).maxOf(this, orElse: orElse);

  /// Returns a list of the [count] largest elements of this [Iterable]. The
  /// elements need to be [Comparable], unless a custom [comparator] is
  /// provided.
  ///
  /// For example
  ///
  ///    [3, 1, 2].largest(2)
  ///
  /// returns `[3, 2]`.
  ///
  List<E> largest(int count, {Comparator<E>? comparator}) =>
      (comparator ?? naturalCompare).largest(this, count);
}
