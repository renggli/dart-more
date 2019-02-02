library more.iterable.zip;

/// Combines the first, second, third, ... elements of each iterable into a new
/// list. The resulting iterable has the length of the shortest input iterable,
/// unless `includeIncomplete` is set to `true`.
///
/// The following expression yields [1, 'a'], [2, 'b']:
///
///     zip([[1, 2],  ['a', 'b']]);
Iterable<List<T>> zip<T>(Iterable<Iterable<T>> iterables,
    {bool includeIncomplete = false}) sync* {
  if (iterables.isEmpty) {
    return;
  }
  final iterators =
      iterables.map((iterable) => iterable.iterator).toList(growable: false);
  for (;;) {
    var hasAll = true, hasAny = false;
    for (var i = 0; i < iterators.length; i++) {
      final hasNext = iterators[i].moveNext();
      hasAll &= hasNext;
      hasAny |= hasNext;
    }
    if (hasAll || (hasAny && includeIncomplete)) {
      yield iterators
          .map((iterator) => iterator.current)
          .toList(growable: false);
    } else {
      return;
    }
  }
}
