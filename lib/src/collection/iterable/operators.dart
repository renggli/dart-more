import '../../../comparator.dart';

extension OperatorsIterableExtension<E> on Iterable<E> {
  /// Returns the minimum of this [Iterable]. The elements need to be
  /// [Comparable], unless a custom [comparator] is provided.
  ///
  /// Throws a [StateError] if the iterable is empty, unless an [orElse]
  /// function is provided.
  ///
  /// For example:
  ///
  /// ```dart
  /// print([3, 1, 2].min());  // 1
  /// ```
  E min({Comparator<E>? comparator, E Function()? orElse}) =>
      (comparator ?? naturalCompare).minOf(this, orElse: orElse);

  /// Returns the maximum of this [Iterable]. The elements need to be
  /// [Comparable], unless a custom [comparator] is provided.
  ///
  /// Throws a [StateError] if the iterable is empty, unless an [orElse]
  /// function is provided.
  ///
  /// For example:
  ///
  /// ```dart
  /// print([3, 1, 2].max());  // 3
  /// ```
  E max({Comparator<E>? comparator, E Function()? orElse}) =>
      (comparator ?? naturalCompare).maxOf(this, orElse: orElse);

  /// Returns the minimum and maximum of this [Iterable] at once. The elements
  /// need to be [Comparable], unless a custom [comparator] is provided.
  ///
  /// Throws a [StateError] if the iterable is empty, unless an [orElse]
  /// function is provided.
  ///
  /// For example:
  ///
  /// ```dart
  /// print([3, 1, 2].minMax());  // (min: 1, max: 3)
  /// ```
  ({E min, E max}) minMax({
    Comparator<E>? comparator,
    ({E min, E max}) Function()? orElse,
  }) => (comparator ?? naturalCompare).minMaxOf(this, orElse: orElse);

  /// Returns a list of the [count] smallest elements of this [Iterable]. The
  /// elements need to be [Comparable], unless a custom [comparator] is
  /// provided.
  ///
  /// For example:
  ///
  /// ```dart
  /// print([3, 1, 2].smallest(2));  // [1, 2]
  /// ```
  List<E> smallest(int count, {Comparator<E>? comparator}) =>
      (comparator ?? naturalCompare).smallest(this, count);

  /// Returns a list of the [count] largest elements of this [Iterable]. The
  /// elements need to be [Comparable], unless a custom [comparator] is
  /// provided.
  ///
  /// For example:
  ///
  /// ```dart
  /// print([3, 1, 2].largest(2));  // [3, 2]
  /// ```
  List<E> largest(int count, {Comparator<E>? comparator}) =>
      (comparator ?? naturalCompare).largest(this, count);
}
