library more.iterable.concat;

/// Combines multiple [iterables] into a single iterable.
///
/// For example:
///
///    var first = [1, 2, 3];
///    var second = new List.of([4, 5]);
///    var third = new Set.of([6]);
///
///    // equals to [1, 2, 3, 4, 5, 6]
///    var concatenation = concat([first, second, third]);
///
Iterable<E> concat<E>(Iterable<Iterable<E>> iterables) =>
    iterables.expand((iterable) => iterable);
