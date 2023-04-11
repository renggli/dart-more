import '../../../collection.dart';

/// Returns an explicit [Comparator] based on an `iterable` of elements.
Comparator<T> explicitComparator<T>(Iterable<T> iterable) {
  final ranks = <T, int>{};
  for (final element in iterable.indexed()) {
    ranks[element.value] = element.key;
  }
  return (a, b) => _rank(ranks, a) - _rank(ranks, b);
}

int _rank<T>(Map<T, int> ranks, T element) {
  final rank = ranks[element];
  if (rank == null) {
    throw StateError('Unable to compare $element with ${ranks.keys}');
  }
  return rank;
}
