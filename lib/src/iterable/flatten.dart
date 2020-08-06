library more.iterable.flatten;

extension FlattenExtension on Iterable {
  /// Creates an iterable with all sub-iterables flattened recursively up to the
  /// specified [depth]. Filters elements that are not of type [E].
  Iterable<E> flatten<E>([int depth = 0xffff]) sync* {
    for (final element in this) {
      if (element is Iterable && depth > 0) {
        yield* element.flatten<E>(depth - 1);
      } else if (element is E) {
        yield element;
      }
    }
  }
}
