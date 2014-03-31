part of iterable;

/**
 * Combines multiple [iterables] into a single iterable.
 *
 * For example:
 *
 *    var first = [1, 2, 3];
 *    var second = new List.from([4, 5]);
 *    var third = new Set.from([6]);
 *
 *    // equals to [1, 2, 3, 4, 5, 6]
 *    var concatenation = concat([first, second, third]);
 */
Iterable/*<E>*/ concat(Iterable<Iterable/*<E>*/> iterables) {
  return iterables.expand((Iterable iterable) => iterable);
}
