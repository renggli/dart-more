// ignore_for_file: deprecated_member_use_from_same_package

import '../../printer.dart';
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

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(ordering, name: 'ordering');
}
