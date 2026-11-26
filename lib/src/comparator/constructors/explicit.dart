/// Returns an explicit [Comparator] based on an [iterable] of elements.
///
/// If [iterable] contains duplicate elements, the rank of the first occurrence
/// wins. Comparing an element not present in [iterable] throws a [StateError].
Comparator<T> explicitComparator<T>(Iterable<T> iterable) {
  final ranks = <T, int>{};
  var index = 0;
  for (final element in iterable) {
    ranks.putIfAbsent(element, () => index++);
  }
  return (a, b) => _rank(ranks, a) - _rank(ranks, b);
}

int _rank<T>(Map<T, int> ranks, T element) {
  final rank = ranks[element];
  if (rank == null) {
    throw StateError('Unable to compare $element: not in explicit ordering');
  }
  return rank;
}
