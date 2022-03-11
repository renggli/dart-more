/// Returns a default comparator for elements of type `E`. Adopted from
/// 'splay_tree.dart' of the Dart collection library.
Comparator<E> getDefaultComparator<E>() {
  final Object compare = Comparable.compare;
  return compare is Comparator<E> ? compare : _dynamicCompare;
}

int _dynamicCompare(dynamic a, dynamic b) => Comparable.compare(a, b);
