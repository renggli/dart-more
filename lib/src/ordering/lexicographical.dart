import 'ordering.dart';

class LexicographicalOrdering<T> extends Ordering<Iterable<T>> {
  const LexicographicalOrdering(this.ordering);

  final Ordering<T> ordering;

  @override
  int compare(Iterable<T> a, Iterable<T> b) {
    final ia = a.iterator, ib = b.iterator;
    while (ia.moveNext()) {
      if (!ib.moveNext()) {
        return 1;
      }
      final result = ordering.compare(ia.current, ib.current);
      if (result != 0) {
        return result;
      }
    }
    return ib.moveNext() ? -1 : 0;
  }
}
