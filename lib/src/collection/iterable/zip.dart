extension ZipIterableExtension<E> on Iterable<Iterable<E>> {
  /// Combines the first, second, third, ... elements of each [Iterable] into a
  /// new list. The resulting iterable has the length of the shortest input
  /// iterable.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = [[1, 2],  ['a', 'b']];
  /// print(input.zip());  // [[1, 'a'], [2, 'b']]
  /// ```
  Iterable<List<E>> zip() sync* {
    if (isEmpty) return;
    final iterators = map(
      (iterable) => iterable.iterator,
    ).toList(growable: false);
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
    final iterators = map(
      (iterable) => iterable.iterator,
    ).toList(growable: false);
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

extension Zip2IterableExtension<T1, T2> on (Iterable<T1>, Iterable<T2>) {
  /// Combines the tuple of iterables to an iterable of tuples. The resulting
  /// iterable has the length of the shortest input iterable.
  ///
  /// For example:
  ///
  /// ```dart
  /// final input = ([1, 2],  ['a', 'b']);
  /// print(input.zip());  // [(1, 'a'), (2, 'b')]
  /// ```
  Iterable<(T1, T2)> zip() sync* {
    final i1 = $1.iterator, i2 = $2.iterator;
    while (i1.moveNext() && i2.moveNext()) {
      yield (i1.current, i2.current);
    }
  }

  /// Combines the tuple of iterables to an iterable of tuples. The resulting
  /// iterable has the length of the longest input iterable, missing values are
  /// padded with `null`.
  Iterable<(T1?, T2?)> zipPartial() =>
      ($1.cast<T1?>(), $2.cast<T2?>()).zipPartialWith((null, null));

  /// Combines the tuple of iterables to an iterable of tuples. The resulting
  /// iterable has the length of the longest input iterable, missing values are
  /// padded with [padding].
  Iterable<(T1, T2)> zipPartialWith((T1, T2) padding) sync* {
    final i1 = $1.iterator, i2 = $2.iterator;
    for (;;) {
      final h1 = i1.moveNext(), v1 = h1 ? i1.current : padding.$1;
      final h2 = i2.moveNext(), v2 = h2 ? i2.current : padding.$2;
      if (h1 || h2) {
        yield (v1, v2);
      } else {
        return;
      }
    }
  }
}
