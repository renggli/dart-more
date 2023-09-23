extension SearchComparator<T> on Comparator<T> {
  /// Performs a binary search of [value] on the sorted [list]. Returns the
  /// index of any element that compares equal, or `-1` if the value is not
  /// found. The result is undefined if the list is not sorted.
  ///
  /// By default the whole [list] is searched, but if [start] and/or [end] are
  /// supplied, only that range is searched.
  int binarySearch(List<T> list, T value, {int? start, int? end}) {
    var min = start ??= 0;
    var max = end ??= list.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final comp = this(list[mid], value);
      if (comp == 0) {
        assert(start <= mid && mid <= end,
            'Index $mid not in inclusive range $start..$end');
        return mid;
      } else if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -1;
  }

  /// Performs a binary search of [value] on the sorted [list]. Returns the
  /// the first suitable insertion index such that
  /// `list[index - 1] < value <= list[index]` (lower bound). The result is
  /// undefined if the list is not sorted.
  ///
  /// By default the whole [list] is searched, but if [start] and/or [end]
  /// are supplied, only that range is searched.
  int binarySearchLower(List<T> list, T value, {int? start, int? end}) {
    var min = start ??= 0;
    var max = end ??= list.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      if (this(list[mid], value) < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    assert(start <= min && min <= end,
        'Index $min not in inclusive range $start..$end');
    return min;
  }

  /// Performs a binary search of [value] on the sorted [list]. Returns the
  /// the last suitable insertion index such that
  /// `list[index - 1] <= value< list[index]` (upper bound). The result is
  /// undefined if the list is not sorted.
  ///
  /// By default the whole [list] is searched, but if [start] and/or [end]
  /// are supplied, only that range is searched.
  int binarySearchUpper(List<T> list, T value, {int? start, int? end}) {
    var min = start ??= 0;
    var max = end ??= list.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      if (this(list[mid], value) <= 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    assert(start <= min && min <= end,
        'Index $min not in inclusive range $start..$end');
    return min;
  }
}
