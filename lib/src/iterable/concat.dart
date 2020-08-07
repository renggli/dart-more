library more.iterable.concat;

extension ConcatExtension<E> on Iterable<Iterable<E>> {
  /// Combines this [Iterable] of [Iterable]s into a single iterable.
  ///
  /// For example:
  ///
  ///    var first = [1, 2, 3];
  ///    var second = new List.of([4, 5]);
  ///    var third = new Set.of([6]);
  ///
  ///    // equals to [1, 2, 3, 4, 5, 6]
  ///    var concatenation = [first, second, third].concat();
  ///
  Iterable<E> concat() => expand<E>((element) => element);
}
