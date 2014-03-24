part of iterable;

/**
 * Combines multiple [iterables] into a single iterable.
 */
Iterable concat(Iterable<Iterable> iterables) {
  return iterables.expand((e) => e.iterator);
}