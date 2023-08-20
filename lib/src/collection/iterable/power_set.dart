import 'combinations.dart';

extension PowerSetIterableExtension<E> on Iterable<E> {
  /// Returns all subsets of this iterable including the empty set and the
  /// complete set itself. The power-set has _2^n_ elements, if the iterable
  /// has length _n_.
  ///
  /// Note that despite the used _set_ terminology, the resulting iterator
  /// contains [List] elements that are not de-duplicated. If you want unique
  /// set-elements, de-duplicate your input [Iterable] before calling this
  /// function.
  ///
  /// For example `['x', 'y', 'z'].powerSet()` yields the following sets:
  ///
  ///     []
  ///     ['x']
  ///     ['y']
  ///     ['z']
  ///     ['x', 'y']
  ///     ['x', 'z']
  ///     ['y', 'z']
  ///     ['x', 'y', 'z']
  ///
  Iterable<List<E>> powerSet() sync* {
    final list = toList(growable: false);
    for (var i = 0; i <= list.length; i++) {
      yield* list.combinations(i);
    }
  }
}
