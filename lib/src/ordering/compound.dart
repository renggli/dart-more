import '../../printer.dart';
import 'ordering.dart';

class CompoundOrdering<T> extends Ordering<T> {
  const CompoundOrdering(this.orderings);

  final List<Ordering<T>> orderings;

  @override
  int compare(T a, T b) {
    for (final ordering in orderings) {
      final result = ordering.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }

  @override
  Ordering<T> compound(Ordering<T> other) =>
      CompoundOrdering([...orderings, other]);

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(orderings, name: 'orderings');
}
