extension SortComparator<T> on Comparator<T> {
  /// Sorts the provided [list] in-place.
  void sort(List<T> list) => list.sort(this);

  /// Returns a sorted copy of the provided [iterable].
  List<T> sorted(Iterable<T> iterable) {
    final list = List.of(iterable, growable: false);
    sort(list);
    return list;
  }
}
