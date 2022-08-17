/// Returns a natural [Comparator] for objects of type `T`.
Comparator<T> naturalComparator<T>() {
  final Object compare = _staticCompare;
  return compare is Comparator<T> ? compare : _dynamicCompare;
}

int _staticCompare(Comparable a, Comparable b) => a.compareTo(b);

int _dynamicCompare(dynamic a, dynamic b) => Comparable.compare(a, b);
