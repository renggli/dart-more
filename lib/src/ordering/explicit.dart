// ignore_for_file: deprecated_member_use_from_same_package

import '../../collection.dart';
import '../../printer.dart';
import 'ordering.dart';

class ExplicitOrdering<T> extends Ordering<T> {
  ExplicitOrdering(Iterable<T> iterable) {
    for (final element in iterable.indexed()) {
      ranking[element.value] = element.key;
    }
  }

  final Map<T, int> ranking = {};

  @override
  int compare(T a, T b) => rank(a) - rank(b);

  int rank(T element) {
    final rank = ranking[element];
    if (rank == null) {
      throw StateError('Unable to compare $element with $this');
    }
    return rank;
  }

  @override
  ObjectPrinter get toStringPrinter =>
      super.toStringPrinter..addValue(ranking, name: 'ranking');
}
