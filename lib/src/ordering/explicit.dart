library more.ordering.explicit;

import 'package:more/ordering.dart';

class ExplicitOrdering<T> extends Ordering<T> {
  final Map<T, int> ranking;

  factory ExplicitOrdering(List<T> list) {
    var ranking = <T, int>{};
    for (var rank = 0; rank < list.length; rank++) {
      ranking[list[rank]] = rank;
    }
    return new ExplicitOrdering._(ranking);
  }

  const ExplicitOrdering._(this.ranking);

  @override
  int compare(T a, T b) => rank(a) - rank(b);

  int rank(T element) {
    var rank = ranking[element];
    if (rank == null) {
      throw new StateError('Unable to compare $element with $this');
    }
    return rank;
  }
}
