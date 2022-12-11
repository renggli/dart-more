/// Returns a reversed natural [Comparator] for objects of type `T`.
Comparator<T> reverseComparator<T>() => _compare;

int _compare(Object? a, Object? b) => (b as Comparable<Object?>).compareTo(a);
