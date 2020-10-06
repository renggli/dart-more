extension ZipExtension<E> on Iterable<Iterable<E>> {
  /// Combines the first, second, third, ... elements of each [Iterable] into a
  /// new list. The resulting iterable has the length of the shortest input
  /// iterable.
  ///
  /// The following expression yields [1, 'a'], [2, 'b']:
  ///
  ///     [[1, 2],  ['a', 'b']].zip();
  ///
  Iterable<List<E>> zip() sync* {
    if (isEmpty) {
      return;
    }
    final iterators =
        map((iterable) => iterable.iterator).toList(growable: false);
    for (;;) {
      final result = <E>[];
      for (final iterator in iterators) {
        if (iterator.moveNext()) {
          result.add(iterator.current);
        } else {
          return;
        }
      }
      yield result;
    }
  }

  /// Combines the first, second, third, ... elements of each [Iterable] into a
  /// new list. The resulting iterable has the length of the longest input
  /// iterable, missing values are padded with `null`.
  Iterable<List<E?>> zipPartial() => cast<Iterable<E?>>().zipPartialWith(null);

  /// Combines the first, second, third, ... elements of each [Iterable] into a
  /// new list. The resulting iterable has the length of the longest input
  /// iterable, missing values are padded with [padding].
  Iterable<List<E>> zipPartialWith(E padding) sync* {
    if (isEmpty) {
      return;
    }
    final iterators =
        map((iterable) => iterable.iterator).toList(growable: false);
    for (;;) {
      var hasAny = false;
      final result = <E>[];
      for (final iterator in iterators) {
        if (iterator.moveNext()) {
          result.add(iterator.current);
          hasAny = true;
        } else {
          result.add(padding);
        }
      }
      if (hasAny) {
        yield result;
      } else {
        return;
      }
    }
  }
}
