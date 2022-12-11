/// Returns a reversed natural [Comparator] for objects of type `T`.
Comparator<T> reverseComparator<T>() {
  const Object compare = _staticCompare;
  return compare is Comparator<T> ? compare : _dynamicCompare;
}

int _staticCompare(Comparable a, Comparable b) => b.compareTo(a);

int _dynamicCompare(dynamic a, dynamic b) => Comparable.compare(b, a);
