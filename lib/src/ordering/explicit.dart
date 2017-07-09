library more.ordering.explicit;

import 'package:more/ordering.dart';

class ExplicitOrdering<T> extends Ordering<T> {
  final Map<T, int> _ranking;

  const ExplicitOrdering(this._ranking);

  @override
  int compare(T a, T b) => _rank(a) - _rank(b);

  int _rank(T element) {
    var rank = _ranking[element];
    if (rank == null) {
      throw new StateError('Unable to compare $element with $this');
    }
    return rank;
  }
}
