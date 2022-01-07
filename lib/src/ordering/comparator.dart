import 'ordering.dart';

class ComparatorOrdering<T> extends Ordering<T> {
  const ComparatorOrdering(this.comparator);

  final Comparator<T> comparator;

  @override
  int compare(T a, T b) => comparator(a, b);

  @override
  Ordering<T> get reversed => ReverseComparatorOrdering<T>(comparator);
}

class ReverseComparatorOrdering<T> extends Ordering<T> {
  const ReverseComparatorOrdering(this.comparator);

  final Comparator<T> comparator;

  @override
  int compare(T a, T b) => comparator(b, a);

  @override
  Ordering<T> get reversed => ComparatorOrdering<T>(comparator);
}
