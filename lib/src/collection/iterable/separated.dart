/// Function type to build elements.
typedef Builder<E> = E Function();

extension SeparatedExtension<E> on Iterable<E> {
  /// Returns an [Iterable] where every element is separated by an element
  /// built by a [separator] builder. Optionally specified [before] and [after]
  /// builders can provide an element at the beginning or the end of the
  /// non-empty iterable.
  ///
  /// Examples:
  ///
  ///    [1, 2, 3].separatedBy(() => 0);   // [1, 0, 2, 0, 3]
  ///    [1, 2].separateBy(() => 0, after: () => -1);   // [1, 0, 2, -1]
  ///
  Iterable<E> separatedBy(Builder<E> separator,
      {Builder<E>? before, Builder<E>? after}) sync* {
    var index = 0;
    for (var iterator = this.iterator; iterator.moveNext(); index++) {
      if (index == 0 && before != null) yield before();
      if (index > 0) yield separator();
      yield iterator.current;
    }
    if (index > 0 && after != null) yield after();
  }
}
