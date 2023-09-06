import 'package:collection/collection.dart';

extension SortComparator<T> on Comparator<T> {
  /// Sorts the provided [list] in-place.
  ///
  /// If [start] (inclusive)  and [end] (exclusive) are provided the sorting
  /// only happens within the specified range.
  ///
  /// If [stable] is set to `true`, a stable merge-sort implementation is used
  /// instead of the standard quick-sort. This means that elements that compare
  /// equal stay in the order of the input.
  void sort(List<T> list, {int? start, int? end, bool stable = false}) {
    start ??= 0;
    end ??= list.length;
    if (stable) {
      mergeSort<T>(list, start: start, end: end, compare: this);
    } else {
      list.sortRange(start, end, this);
    }
  }

  /// Returns a sorted copy of the provided [iterable].
  ///
  /// If [start] (inclusive)  and [end] (exclusive) are provided the sorting
  /// only happens within the specified range.
  ///
  /// If [stable] is set to `true`, a stable merge-sort implementation is used
  /// instead of the standard quick-sort. This means that elements that compare
  /// equal stay in the order of the input.
  ///
  /// By default a more efficient fixed-length list is returned, unless
  /// [growable] is set to `true`.
  List<T> sorted(Iterable<T> iterable,
      {int? start, int? end, bool stable = false, bool growable = false}) {
    final list = List.of(iterable, growable: growable);
    sort(list, start: start, end: end, stable: stable);
    return list;
  }
}
