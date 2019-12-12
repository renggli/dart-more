library more.iterable.concat;

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
extension ConcatExtension<E> on Iterable<Iterable<E>> {
  Iterable<E> concat() => expand((iterable) => iterable);
}
