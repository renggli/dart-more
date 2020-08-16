extension ZipExtension<E> on Iterable<Iterable<E>> {
  /// Combines the first, second, third, ... elements of each [Iterable] into a
  /// new list. The resulting iterable has the length of the shortest input
  /// iterable, unless `includePartial` is set to `true`.
  ///
  /// The following expression yields [1, 'a'], [2, 'b']:
  ///
  ///     [[1, 2],  ['a', 'b']].zip();
  ///
  Iterable<List<E>> zip({bool includePartial = false}) sync* {
    if (isEmpty) {
      return;
    }
    final iterators =
        map((iterable) => iterable.iterator).toList(growable: false);
    for (;;) {
      var hasAll = true, hasAny = false;
      for (var i = 0; i < iterators.length; i++) {
        final hasNext = iterators[i].moveNext();
        hasAll &= hasNext;
        hasAny |= hasNext;
      }
      if (hasAll || (hasAny && includePartial)) {
        yield iterators
            .map((iterator) => iterator.current)
            .toList(growable: false);
      } else {
        break;
      }
    }
  }
}
